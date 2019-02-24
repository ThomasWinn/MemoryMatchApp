//
//  ViewController.swift
//  memoryGame
//
//  Created by Thomas Nguyen on 8/24/18.
//  Copyright © 2018 Thomas Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var model = cardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 40 * 1000 // 10 seconds
    
    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call the getCards method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        SoundManager.playSound(.shuffle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK - Timer Methods
    
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        //Convert to seconds
        
        let seconds = String(format: "%.2f", milliseconds / 1000)
        
        //Set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        
        //When timer reaches 0...
        if milliseconds <= 0 {
            
            //Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //Check if there are any cards unmatched
            checkGameEnded()
        }
    }
    //MARK: - UICollectionView Protocol Methods
    
    //ask for number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    //called 16 times one for each time a cell is called returns cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardLayout", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the collection view is trying to say
        let card = cardArray[indexPath.row]
        
        // Set that card for the cell
        cell.setCard(card)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Check if there's any time left prevents player from keeping on pressing on past timer elapsed
        if milliseconds <= 0 {
            return
        }
        
        //Get the cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isCardFlipped == false && card.isCardMatched == false {
            
            //Flip the card
            cell.flip()
            
            //Play flip sound
            SoundManager.playSound(.flip)
            
            //set the status of card
            card.isCardFlipped = true
            
            //Determine if first card or second card that's flipped over
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            
            else{
                //This is the second card being flipped
                
                //TODO: Perform matching logic
                checkForMatches(indexPath)
            }
            
        }
    } //End the didSelectItemAt method
    
    // MARK: - Game Logic Methods
    
    func checkForMatches( _ secondFlippedCardIndex:IndexPath) {
        //Get the cells for the two cards that were revealed
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //Get the cards for the two cards that were revealed
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //Compare the two cards
        if cardOne.cardName == cardTwo.cardName {
            
            //It's a match
            
            //play match sound
            SoundManager.playSound(.match)
            
    
            //Set the statuses of the cards
            cardOne.isCardMatched = true
            cardTwo.isCardMatched = true
            
            //Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //Check if there are any cards left unmatched
            checkGameEnded()
            
        }
        else {
            
            // It's not a match
            
            //play nomatch sound
            SoundManager.playSound(.nomatch)
            
            //Set the statuses of the cards
            cardOne.isCardFlipped = false
            cardTwo.isCardFlipped = false
            
            //Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
            
        }
        
        //Tell the collectionView to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        //Reset the property that tracks the first card flipeped
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded() {
        
        //Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray{
            
            if card.isCardMatched == false {
                isWon = false
                break
            }
        }
        
        //Messaging variables
        var title = ""
        var message = ""
        
        //If not, then user has won, stop the timer
        
        if isWon == true {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won"
        }
        else {
            
            //If  there are unmatched cards, check if there's any time left
            
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
            
        }
        
        //Show won/lost messaging
        showAlert(title, message)
        
        //if there are unmatched cards, check if there's and time left
        
        //show won/lost message
    }
    
    func showAlert(_ title:String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        //shows the pressable button on alert
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        
        //allows the alert action to be pressed
        alert.addAction(alertAction)
        
        //presents everything as a popup
        present(alert, animated: true, completion: nil)
    }
    
    
} //End View Controller class

