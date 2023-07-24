//
//  Cardify.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/22/23.
//

import SwiftUI

struct Cardify: AnimatableModifier { // Both a 'ViewModifier' - implements func body and an 'Animatable' - implements animatableData
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double { // Tells swift we want to animation this parameter
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack { // Struct with it's content variable defined by the function (alignment is default)
            let shape = RoundedRectangle(cornerRadius: DrawingsConstants.cornerRadius) // Local constant variable to avoid repeats
            if rotation < 90 { // Card is in state of revealing (controlled by FaceUp)
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingsConstants.lineWidth)
            } else { // Card's is in state of hiding (controlled by FaceUp)
                shape.fill()
            }
            content // Have content always on-screen. Otherwise, when 2nd matching card is flipped, no animation occurs (since isMatched = true by the time it's face up i.e., on screen)
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingsConstants {
        static let cornerRadius: CGFloat = 15
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
