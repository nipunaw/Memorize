//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/17/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
