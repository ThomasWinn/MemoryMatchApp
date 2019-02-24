//
//  cardModel.swift
//  memoryGame
//
//  Created by Thomas Nguyen on 8/24/18.
//  Copyright © 2018 Thomas Nguyen. All rights reserved.
//

import Foundation

class cardModel {
    
    func getCards() -> [Card] {
        
        //Declare an array to store numbers we've already generated
        var generatedNumbersArray = [Int]()
        
        //Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        
        //Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            
            let randomNumber = arc4random_uniform(13) + 1
            
            //Ensure the random number isn't one we already have
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                //log the number
                print(randomNumber)
                
                //Store the number into the generatedNumberArray
                generatedNumbersArray.append(Int(randomNumber))
                
                //Create first card object
                let cardOne = Card()
                cardOne.cardName = "card\(randomNumber)"
                //cardOne.cardName = "card\(randomNumber)"
                
                //Add to array
                generatedCardsArray.append(cardOne)
                
                //Create second card object -> mirror of first
                let cardTwo = Card()
                cardTwo.cardName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
            }
        }
        //Randomize the array -> swap
        
        for i in 0...generatedCardsArray.count - 1 {
            
            //Find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            //Swap the two cards
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        //Return the array
        return generatedCardsArray
    }
}
