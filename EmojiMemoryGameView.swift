//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/17/23.
//

import SwiftUI


// View - UI, declarative, reactive, stateless, signals/calls intent
struct EmojiMemoryGameView: View { // Specify struct behaves like a View (adheres to 'View' protocol)
    @ObservedObject var game: EmojiMemoryGame // Designate var to hear announcements (needs to be var)
    
    @Namespace private var dealingNamespace
    
    var body: some View { // Function below defines what variable 'body' evaluates to (it will be some view)
        ZStack(alignment: .bottom) {
            VStack {
                Text(game.themeName).font(.largeTitle)
                Text("Score: \(game.score)")
                gameBody
                HStack {
                    shuffleButton
                    Spacer()
                    newGameButton
                }.padding(.horizontal)
                
            }
            deckBody
        }
        .padding()

    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in //Creating your own custom Container View to dynamically size/fit cards
            if isUndealt(card) || card.isMatched && !card.isFaceUp { //To use this if/else logic in AspectVGrid, AspectVGrid's content needs to have viewbuilder flag
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace) // Matches animation of this view with one below
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale)) // Transition animation applies to Views that come in/out of view - common in if/forEach
                    .zIndex(zIndex(of: card)) // So card on screen is in a certain order
                    .onTapGesture {
                        withAnimation { // Explicit animation - often associated with intent functions
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(game.themeColor) // Originally used onAppear - keeps the cards off screen until container appears. Otherwise, you can't animate transition of cards in
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace) // Matches animation of this view with one above
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card)) // So card in deck is in a certain order
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(game.themeColor)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) { // We do multiple card-dealing animations at once, but with varying delays to give appearance of dealing one at a time
                    deal(card) // Helps to keep card view out of sync with container
                }
            }
        }
    }
    
    var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation { // Explicit animation: All view modifier arguments that can be animated, are animated
                game.shuffle()
            }
        }
    }
    
    var newGameButton: some View {
        Button("New Game") {
            withAnimation {
                dealt = [] // reset dealt view
                game.newGame()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                    .padding(5).opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.easeInOut(duration: 1), value: card.isMatched) // Implicit animation (animates already on-screen views). By using new version of .animation() with value parameter, it's more akin to explicit animation
                    .font(font(in: geometry.size)) // Otherwise, with pure implicit, you'd have to modify .font calculation as it's non-animatable and causes glitces
            }
            .cardify(isFaceUp: card.isFaceUp) // Our own custom view modifier (which takes a view as 'content' and returns some modified view)
        })
    }
    
    private func font (in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingsConstants.fontScale)
    }
    
    private struct DrawingsConstants {
        static let cornerRadius: CGFloat = 15
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
    
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(theme: .constant(ThemeStore(named: "Preview").theme(at: 0)))
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}
