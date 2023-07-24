//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/18/23.
//

import SwiftUI

//View Model - announcer, interpreter, gatekeeper
class EmojiMemoryGame: ObservableObject { // Designate as an 'announcer' of changes
    typealias Card = MemoryGame<String>.Card // Type alias allows us to simply call this typing a 'Card'
    
    private static func createMemoryGame(theme: Theme<String>) -> MemoryGame<String> { //
        MemoryGame<String>(numberOfPairsOfCards: theme.availableThemes[theme.currentTheme].numPairs) {_ in
            theme.availableThemes[theme.currentTheme].emoji.randomElement()!
        }
    }
    
    init() {
        let baseTheme = Theme<String>(name: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹"], numPairs: 4, cardColor: "red")
        theme = baseTheme
        theme.addTheme(name: "People", emojis: ["😀", "😃", "😄", "😁", "😆", "🥹", "😅", "😂"], numPairs: 10, cardColor: "blue")
        theme.addTheme(name: "Sports", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐"], numPairs: 8, cardColor: "green")
        theme.addTheme(name: "Food", emojis: ["🍏", "🍎", "🍐"], numPairs: 2, cardColor: "orange")
        theme.addTheme(name: "Vehicles", emojis: ["🚗", "🚕"], numPairs: 2, cardColor: "yellow")
        theme.addTheme(name: "Devices", emojis: ["⌚️", "📱"], numPairs: 3, cardColor: "purple")
        
        let emojis = baseTheme.availableThemes[baseTheme.currentTheme].emoji.shuffled()
        model = MemoryGame<String>(numberOfPairsOfCards: theme.availableThemes[theme.currentTheme].numPairs) {pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model: MemoryGame<String> // We can create a collection of memory games with different themes?
    private var theme: Theme<String>
    // Published - designates object to observe and announce the changes of
    // private - no write or read access to this 'model' variable
    
    
    // Getter methods
    var cards: Array<Card> {
        model.cards // Can read this from Model (cards is read-only in Model)
    }
    
    var themeName: String {
        theme.availableThemes[theme.currentTheme].name
    }
    
    var themeColor: Color { //Interprets color and returns
        switch theme.availableThemes[theme.currentTheme].cardColor {
            case "red": return Color.red
            case "blue": return Color.blue
            case "green": return Color.green
            case "orange": return Color.orange
            case "yellow": return Color.yellow
            case "purple": return Color.purple
            default: return Color.pink
        }
    }
    
    var score: Int {
        model.score
    }
    
    
    // MARK: - Intent(s)
    func newGame() {
        theme.changeTheme()
        
        let emojis = theme.availableThemes[theme.currentTheme].emoji.shuffled()
//        model = EmojiMemoryGame.createMemoryGame(theme: theme)
        
        model = MemoryGame<String>(numberOfPairsOfCards: theme.availableThemes[theme.currentTheme].numPairs) {pairIndex in
            emojis[pairIndex] // Provide random element
        }
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
}


// Okay based on the hints, here are my thoughts
// We add a 'Theme' structure to our Model (either by adding to MemoryGame.swift or more likely, a new Theme.swift)
// 'Theme' will serve as our data whereas 'MemoryGame' will be our logic
// We will add access the model's data via 'Theme' and pass that to the logic in 'MemoryGame'
// When we add UI to change themes, we need to also add additional intent

// I have completed Assignment 2, but I'm uncertain about the 'Theme' structure as well as some elements of 'static' functions in View Model
