import SwiftUI

extension Theme {
    init(name: String, color: Color, emojis: String, numPairs: Int, id: Int) {
        self.init(name: String, color: RGBAColor(color: color), emojis: String, numPairs: Int, id: Int)
    }  
}