//
//  Theme.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/19/23.
//

import Foundation

struct Theme<CardContent> where CardContent: Hashable { // Defines the 'Theme' structure
    
    struct Attributes {
        let name : String
        let emoji: Array<CardContent>
        let numPairs: Int
        let cardColor: String
    }
    
    private(set) var currentTheme: Int // Theme index
    private(set) var availableThemes: Array<Attributes>
    
    init(name: String, emojis: Array<CardContent>, numPairs: Int, cardColor: String) {
        let finalNumPairs = numPairs <= emojis.count ? numPairs : emojis.count
        availableThemes = [Attributes(name: name, emoji: emojis, numPairs: finalNumPairs, cardColor: cardColor)] //Starting theme
        currentTheme = 0
    }
    
    mutating func addTheme(name: String, emojis: Array<CardContent>, numPairs: Int, cardColor: String) {
        let finalNumPairs = numPairs <= emojis.count ? numPairs : emojis.count
        availableThemes.append(Attributes(name: name, emoji: emojis, numPairs: finalNumPairs, cardColor: cardColor)) //Add a theme
    }
    
    mutating func changeTheme() {
        currentTheme = Int.random(in: availableThemes.indices)
    }
}
