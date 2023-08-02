//
//  Theme.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 8/1/23.
//

import Foundation

struct Theme: Identifiable, Codable, Hashable { // Theme model
    var name: String
    var color: RGBAColor
    var emojis: String
    var numPairs: Int
    var id: Int

    init(name: String, color: RGBAColor, emojis: String, numPairs: Int, id: Int) {
        self.name = name
        self.color = color
        self.emojis = emojis
        self.numPairs = numPairs
        self.id = id
    }
}
