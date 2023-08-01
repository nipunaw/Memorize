//
//  ThemeManager.swift
//  EmojiArt
//
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var store: ThemeStore
    
    @State private var editMode: EditMode = .inactive
    @State private var themeToEdit: Theme?
    @State private var activeGames: [Int:EmojiMemoryGame] = [:]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    if let game = accessMemoryGame(for: theme) {
                        NavigationLink(destination: EmojiMemoryGameView(game: game)) {
                            VStack(alignment: .leading) {
                                Text(theme.name)
                                Text("\(theme.numPairs) pairs from \(theme.emojis)")
                            }
                            .gesture(editMode == .active ? tap(theme: theme) : nil)
                        }
                    }
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Memorize")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                EditButton()
            }
            .environment(\.editMode, $editMode)
            .popover(item: $themeToEdit) { theme in
                ThemeEditor(theme: $store.themes[theme])
            }
        }
    }
    
    private func accessMemoryGame(for theme: Theme) -> EmojiMemoryGame? {
        if activeGames[theme.id] == nil {
            activeGames[theme.id] = EmojiMemoryGame(theme: theme) // This is recursively (continually) updating the view
        }
        return activeGames[theme.id]
    }
        
    
    private func tap(theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            themeToEdit = theme
        }
    }
}

struct ThemeManager_Previews: PreviewProvider {
    static var previews: some View {
        ThemeManager()
            .environmentObject(ThemeStore(named: "Default"))
            .previewDevice("iPhone 8")
            .preferredColorScheme(.light)
    }
}
