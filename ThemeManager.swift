//
//  ThemeManager.swift
//  EmojiArt
//
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var store: ThemeStore
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(game: EmojiMemoryGame(theme: $store.themes[theme]))) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                            Text(theme.numPairs + " pairs from " + theme.emojis)
                        }
                        .gesture(editMode == .active ? tap : nil)
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
        }
    }
    
    var tap: some Gesture {
        TapGesture().onEnded { }
    }
}

struct ThemeManager_Previews: PreviewProvider {
    static var previews: some View {
        ThemeManager()
            .previewDevice("iPhone 8")
            .environmentObject(ThemeStore(named: "Preview"))
            .preferredColorScheme(.light)
    }
}
