//
//  MemoryGame.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/18/23.
//

import Foundation

// Model - Data + Logic (the 'truth' of the program)
struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card> //Read-only
    private(set) var score: Int
    private var indexOfTheOneAndOnlyFaceUpCard: Int? { // Computed property = every time variable is called, property is computed
        get { cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly } // Filters to face-up card indices and returns if there's only one (extended functionality)
        set { cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)} } // For each index in card indices, set face down except for card turned over
    }
    private var seenIndexes: Set<Int>
    
    
    mutating func choose(_ card: Card) { // Function is mutating as it changes self vars (immutable)
            if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}), // Card index has a matching id
               !cards[chosenIndex].isFaceUp, // Card is face down
               !cards[chosenIndex].isMatched // Card is unmatched
            {
            
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard { // One card is already up
                if cards[chosenIndex].content == cards[potentialMatchIndex].content { // Card flipped matches one already up (adjust matched state and score)
                    cards[chosenIndex].isMatched = true // Set both as matched
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else { // Card flipped doesn't match one already up (potentially adjust score)
                    if !seenIndexes.insert(potentialMatchIndex).inserted {
                        score -= 1
                    }
                    if !seenIndexes.insert(chosenIndex).inserted {
                        score -= 1
                    }
                }
                cards[chosenIndex].isFaceUp = true // You always set second card to face up
                
            } else { // 0 or 2 cards are up and you flip a card -> you ensure everything becomes face down except the card you flipped up
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            } 
   
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        // Add numberOfPairsOfCards x2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2)) // Provides content and unique 'id'
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
        score = 0
        seenIndexes = []
    }
    
    struct Card: Identifiable { // Card adheres to 'Identifiable' protocol with var 'id'
        var isFaceUp = false
        var isMatched = false
        let content: CardContent //Content is constant
        let id: Int //ID is constant
    }

}

extension Array {
    var oneAndOnly: Element? {
        if self.count == 1 {
            return first
        } else {
            return nil
        }
    }
}
