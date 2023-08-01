//
//  Theme.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/19/23.
//

import Foundation

struct Theme: Identifiable, Codable, Hashable {
    var name: String
    var color: RGBAColor
    var emojis: String
    var numPairs: Int
    var id: Int

    fileprivate init(name: String, color: RGBAColor, emojis: String, numPairs: Int, id: Int) {
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
            addTheme(named: "Vehicles", color: Color.green, emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜")
            addTheme(named: "Sports", color: Color.red, emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳")
            addTheme(named: "Music", color: Color.blue, emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻")
            addTheme(named: "Animals", color: Color.yellow, emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔")
            addTheme(named: "Animal Faces", color: Color.orange, emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲")
            addTheme(named: "Flora", color: Color.purple, emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻")
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
    
    // Might have to make emojis optional
    func addTheme(named name: String, color: Color, emojis: String = "", numPairs: Int? = nil, at index: Int = 0) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1 // Find a unique ID
        let safeNumPairs = numPairs != nil && numPairs! <= emojis.count ? numPairs! : emojis.count
        let theme = Theme(name: name, color: color, emojis: emojis, numPairs: safeNumPairs, id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    } 
}
