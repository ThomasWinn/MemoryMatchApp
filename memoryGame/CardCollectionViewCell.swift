//
//  CardCollectionViewCell.swift
//  memoryGame
//
//  Created by Thomas Nguyen on 8/24/18.
//  Copyright © 2018 Thomas Nguyen. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontCardView: UIImageView!
    
    @IBOutlet weak var backCardView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        
        //Keep track of the card that gets passed in
        self.card = card
        
        
        if card.isCardMatched == true {
            
            //If the card has been matched, then make the image views Invisible
            backCardView.alpha = 0
            frontCardView.alpha = 0
            
            return
        }
        else {
            // If the card has not been matched, then make the image views Visible
            backCardView.alpha = 1
            frontCardView.alpha = 1
        }
        
        
        
        frontCardView.image = UIImage(named: card.cardName)
        
        //Determine if the card is in a flipped up state or flipped down state
        if card.isCardFlipped == true {
            //Make sure the front image view is on top
            UIView.transition(from: backCardView, to: frontCardView, duration: 0.3, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
        }
        else {
            //Make sure the back image view is on top
            UIView.transition(from: frontCardView, to: backCardView, duration: 0.3, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
        }
    }
    
    func flip() {
        UIView.transition(from: backCardView, to: frontCardView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontCardView, to: self.backCardView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
    }
    
    func remove() {
        
        //Remove both image views from being visible
        backCardView.alpha = 0
        
        
        //Animate
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontCardView.alpha = 0
        }, completion: nil)
        
    }
}
