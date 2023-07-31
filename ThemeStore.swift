//
//  Theme.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/19/23.
//

import Foundation

struct Theme: Identifiable, Codable, Hashable {
    var name: String
    var color: String
    var emojis: String
    var numPairs: Int
    var id: Int

    fileprivate init(name: String, color: String, emojis: String, numPairs: Int, id: Int) {
        self.name = name
        self.color = color
        self.emojis = emojis
        self.numPairs = numPairs
        self.id = id
    }
}


class ThemeStore: ObservableObject {
    let name: String

    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }

    private var userDefaultsKey: String {
        "ThemeStore:" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }

     private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode(Array<Theme>.self, from: jsonData) {
            themes = decodedThemes
        }
    }

    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            addTheme(named: "Vehicles", color: "red", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜")
            addTheme(named: "Sports", color: "blue", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳")
            addTheme(named: "Music", color: "green", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻")
            addTheme(named: "Animals", color: "purple", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔")
            addTheme(named: "Animal Faces", color: "orange", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲")
            addTheme(named: "Flora", color: "yellow", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻")
        }
    }
    
    // MARK: - Intent
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    @discardableResult
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
    
    func addTheme(named name: String, color: String, emojis: String? = nil, numPairs: Int = emojis.count, at index: Int = 0) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1 // Find a unique ID
        let safeNumPairs = numPairs <= emojis.count ? numPairs : emojis.count // Determine safe number of pairs
        let theme = Theme(name: name, color: color, emojis: emojis ?? "", numPairs: safeNumPairs, id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    } 
}
