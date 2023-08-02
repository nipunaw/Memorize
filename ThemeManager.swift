//
//  ThemeManager.swift
//  EmojiArt
//
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var store: ThemeStore
    @State private var editMode: EditMode = .inactive
    @State private var addMode: Bool = false
    @State private var themeToEdit: Theme?
    @State private var themeToAdd: Theme?
    @State private var newTheme: Theme?
    @State private var activeGames: [Int:EmojiMemoryGame] = [:]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    if let game = accessMemoryGame(for: theme) {
                        NavigationLink(destination: EmojiMemoryGameView(game: game)) {
                            VStack(alignment: .leading) {
                                Text(theme.name).bold().foregroundColor(theme.convertedColor)
                                Text("\(theme.numPairs) pairs from \(theme.emojis.count < 5 ? theme.emojis : theme.emojis.prefix(4)+"...")")
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
                ToolbarItem(placement: .navigationBarLeading) {addButton}
                ToolbarItem {EditButton()}
            }
            .environment(\.editMode, $editMode)
            .sheet(item: $themeToEdit) { theme in // sheet instead of popover for iPad UI
                ThemeEditor(theme: $store.themes[theme])
                    .onChange(of: store.themes[theme]) { changedTheme in
                        activeGames[theme.id]?.changeTheme(theme: changedTheme) // You can change theme on existing game, or create new game
                    }
            }
            .sheet(item: $themeToAdd) { theme in // sheet instead of popover for iPad UI
                ThemeEditor(theme: $store.themes[theme])
                    .onDisappear {
                        activeGames[theme.id] = EmojiMemoryGame(theme: store.themes[theme]) // You create new game once it disappears
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationViewStyle(StackNavigationViewStyle()) // For iPad UI (edge cases: artifacting when re-arranging themes; editing requires clicking on name)
    }
    
    var addButton : some View {
        Button {
            store.addTheme(named: "New Theme", color: Color.red, emojis: "😀😇")
            themeToAdd = store.themes.first
        } label: {
            Image(systemName: "plus")
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
