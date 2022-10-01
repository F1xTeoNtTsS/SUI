//
//  MemoGameContentView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import SwiftUI

class EmojiStock {
    public let vehiclesEmoji = ["🚗", "🚕", "🚌", "🚎", "🚑", "🚜", "🚛", "🚚"]
    public let animalsEmoji = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]
    public let flagsEmoji = ["🏴", "🏳️", "🏁", "🚩", "🏳️‍🌈", "🏴‍☠️", "🇰🇷", "🇮🇩"]
}

struct MemoGameContentView: View {
    private enum Theme: CaseIterable {
        case flags, vehicles, animals
    }
    
//    @State var emojis: [String]
//    @State var emojiCount = 7
    
//    init() {
//        self.emojiStock = EmojiStock()
//        self.emojis = emojiStock.defaulEmoji.shuffled()
//    }
    
    @ObservedObject var viewModel: MemoGameViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Memo game").font(.system(.title)).foregroundColor(.cyan)
                    .onTapGesture {
//                        self.viewModel.cards = viewModel.cards.shuffled()
                    }
                Spacer()
                
                ForEach(Theme.allCases, id: \.self) { theme in
//                    self.makeChoseThemeButton(theme: theme)
                }.foregroundColor(.cyan).frame(width: 55)
            }
            
            ScrollView {
                let gi = GridItem(.adaptive(minimum: 70, maximum: 300))
                LazyVGrid(columns: [gi]) {
                    ForEach(self.viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                self.viewModel.onTapCard(card: card)
                            }
                    }
                }
            }
            Spacer(minLength: 40)
        }
        .padding()
        .font(.largeTitle)
    }
    
//    private func makeChoseThemeButton(theme: Theme) -> some View {
//        var emojis: [String] = []
//        var imageName: String = ""
//        var title: String = ""
//
//        switch theme {
//        case .flags:
//            emojis = emojiStock.flagsEmoji
//            imageName = "flag.circle"
//            title = "Flags"
//        case .vehicles:
//            emojis = emojiStock.vehiclesEmoji
//            imageName = "car.circle"
//            title = "Vehicles"
//        case .animals:
//            emojis = emojiStock.animalsEmoji
//            imageName = "pawprint.circle"
//            title = "Animals"
//        }
//        return VStack {
//            Button {
//                self.emojis = emojis.shuffled()
//            } label: {
//                Image(systemName: imageName)
//            }
//            Text(title).font(.system(size: 14, weight: .medium, design: .rounded))
//        }
//    }
}

struct CardView: View {
    let card: MemoGameModel<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            shape.fill().foregroundColor(.white)
            
            Text(self.card.content).font(.largeTitle)
            
            if self.card.isFaceUp {
                shape.strokeBorder(lineWidth: 4).foregroundColor(.cyan)
            } else {
                shape.foregroundColor(.cyan)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let memoGameViewModel = MemoGameViewModel()
        MemoGameContentView(viewModel: memoGameViewModel)
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}
