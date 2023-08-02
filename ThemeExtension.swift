import SwiftUI

extension Theme {
    init(name: String, color: Color, emojis: String, numPairs: Int, id: Int) {
        self.init(name: name, color: RGBAColor(color: color), emojis: emojis, numPairs: numPairs, id: id)
    }
    
    var convertedColor: Color {
        get { Color(rgbaColor: color) }
        set { color = RGBAColor(color: newValue) }
    }
}
