//
//  ThemeEditor.swift
//  EmojiArt
//
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    @State var showEmojiAlert: Bool = false
    //private let colors = ["red", "blue", "green", "purple", "orange", "yellow"]
    
    var body: some View {
        Form {
            nameSection
            removeEmojiSection
            addEmojisSection
            cardCountSection
            colorSection
        }
        .navigationTitle("Edit \(theme.name)")
        .alert("Need at least 2 Emojis", isPresented: $showEmojiAlert) {}
        //.frame(minWidth: 300, minHeight: 350)
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
        Section(header: Text("Emojis - Tap Emojis to exclude")) {
            let emojis = theme.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                if theme.emojis.count > 2 {
                                    theme.emojis.removeAll(where: { String($0) == emoji })
                                    if theme.numPairs > theme.emojis.count {
                                        theme.numPairs = theme.emojis.count
                                    }
                                } else {
                                    showEmojiAlert = true
                                }
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
            ColorPicker("Color", selection: $theme.convertedColor)
        }
    }

}
