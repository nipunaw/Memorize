//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/18/23.
//

import SwiftUI

//View Model - announcer, interpreter, gatekeeper
class EmojiMemoryGame: ObservableObject { // Designate as an 'announcer' of changes
    typealias Card = MemoryGame<Character>.Card // Type alias allows us to simply call this typing a 'Card'
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<Character> {
        let randomEmojis = theme.emojis.shuffled()
        return MemoryGame<Character>(numberOfPairsOfCards: theme.numPairs) {pairIndex in
            randomEmojis[pairIndex]
        }
    }
    
    init(theme: Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    @Published private var model: MemoryGame<Character> // We can create a collection of memory games with different themes?
    private var theme: Theme // Don't need to use 'didSet' property since we have changeTheme method below
    // Published - designates object to observe and announce the changes of
    // private - no write or read access to this 'model' variable
    
    
    // Getter methods
    var cards: Array<Card> {
        model.cards // Can read this from Model (cards is read-only in Model)
    }
    
    var themeName: String {
        theme.name
    }
    
    var themeColor: Color { //Interprets color and returns
        Color(rgbaColor: theme.color)
    }
    
    var score: Int {
        model.score
    }
    
    var gameStarted: Bool {
        model.gameStarted
    }
    
    // MARK: - Intent(s)
    func newGame() {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }

    func changeTheme(theme: Theme) {
        self.theme = theme
        newGame()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func startGame() {
        model.startGame()
    }
    
}


// Okay based on the hints, here are my thoughts
// We add a 'Theme' structure to our Model (either by adding to MemoryGame.swift or more likely, a new Theme.swift)
// 'Theme' will serve as our data whereas 'MemoryGame' will be our logic
// We will add access the model's data via 'Theme' and pass that to the logic in 'MemoryGame'
// When we add UI to change themes, we need to also add additional intent

// I have completed Assignment 2, but I'm uncertain about the 'Theme' structure as well as some elements of 'static' functions in View Model
