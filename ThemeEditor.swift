//
//  ThemeEditor.swift
//  EmojiArt
//
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    private let colors = ["red", "blue", "green", "purple", "orange", "yellow"]
    
    var body: some View {
        Form {
            nameSection
            addEmojisSection
            removeEmojiSection
            cardCountSection
            colorSection
        }
        .navigationTitle("Edit \(theme.name)")
        .frame(minWidth: 300, minHeight: 350)
    }
    
    var nameSection: some View {
        Section(header: Text("Theme Name")) {
            TextField("Name", text: $theme.name)
        }
    }
    
    @State private var emojisToAdd = ""
    
    var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis = (emojis + theme.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    var removeEmojiSection: some View {
        Section(header: Text("Remove Emoji")) {
            let emojis = theme.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
    
    var cardCountSection: some View {
        Section(header: Text("Card Count")) {
            Stepper("\(theme.numPairs) Pairs", value: $theme.numPairs, in: 2...theme.emojis.count)
        }
    }
    
    var colorSection: some View {
        Section(header: Text("Color")) {
            Picker("Theme Color", selection: $theme.color) {
                ForEach(colors, id: \.self) {
                    Text($0)
                }
            }
        }
    }

}
