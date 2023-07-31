//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/17/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    @StateObject var themeStore = ThemeStore(named: "Default")
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
                .environmentObject(themeStore)
        }
    }
}
