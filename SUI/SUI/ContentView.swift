//
//  ContentView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import SwiftUI

class EmojiStock {
    public let defaulEmoji = ["🤗", "👽", "🫣", "🤡", "🤖", "😮", "🤠", "😵‍💫"]
    public let vehiclesEmoji = ["🚗", "🚕", "🚌", "🚎", "🚑", "🚜", "🚛", "🚚"]
    public let animalsEmoji = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]
    public let flagsEmoji = ["🏴", "🏳️", "🏁", "🚩", "🏳️‍🌈", "🏴‍☠️", "🇰🇷", "🇮🇩"]
}

struct ContentView: View {
    private enum Theme: CaseIterable {
        case flags, vehicles, animals
    }
    
    let emojiStock: EmojiStock
    @State var emojis: [String]
    @State var emojiCount = 3
    
    init() {
        self.emojiStock = EmojiStock()
        self.emojis = emojiStock.defaulEmoji.shuffled()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Cards memo").font(.system(.title)).foregroundColor(.cyan)
                    .onTapGesture {
                        self.emojis = emojiStock.defaulEmoji.shuffled()
                    }
                Spacer()
                
                ForEach(Theme.allCases, id: \.self) { theme in
                    self.makeChoseThemeButton(theme: theme)
                }.foregroundColor(.cyan).frame(width: 55)
            }
            
            ScrollView {
                let gi = GridItem(.adaptive(minimum: 70, maximum: 300))
                LazyVGrid(columns: [gi]) {
                    ForEach(emojis[0...self.emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            Spacer(minLength: 40)
            
//            HStack {
//                self.addButton
//                Spacer()
//                self.removeButton
//            }
//            .padding(.horizontal)
//            .foregroundColor(.cyan)
        }
        .padding()
        .font(.largeTitle)
    }
    
    private var addButton: some View {
        Button {
            if self.emojiCount < self.emojis.count - 1 {
                self.emojiCount += 1
            }
        } label: {
            Image(systemName: "plus.rectangle.portrait")
        }
    }
    
    private var removeButton: some View {
        Button {
            if self.emojiCount > 0 {
                self.emojiCount -= 1
            }
        } label: {
            Image(systemName: "minus.rectangle.portrait")
        }
    }
    
    private func makeChoseThemeButton(theme: Theme) -> some View {
        var emojis: [String] = []
        var imageName: String = ""
        var title: String = ""
        
        switch theme {
        case .flags:
            emojis = emojiStock.flagsEmoji
            imageName = "flag.circle"
            title = "Flags"
        case .vehicles:
            emojis = emojiStock.vehiclesEmoji
            imageName = "car.circle"
            title = "Vehicles"
        case .animals:
            emojis = emojiStock.animalsEmoji
            imageName = "pawprint.circle"
            title = "Animals"
        }
        return VStack {
            Button {
                self.emojis = emojis.shuffled()
            } label: {
                Image(systemName: imageName)
            }
            Text(title).font(.system(size: 14, weight: .medium, design: .rounded))
        }
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp: Bool = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            shape.fill().foregroundColor(.white)
            
            Text(self.content).font(.largeTitle)
            
            if self.isFaceUp {
                shape.strokeBorder(lineWidth: 4).foregroundColor(.cyan)
            } else {
                shape.foregroundColor(.cyan)
            }
            
        }.onTapGesture {
            self.isFaceUp = !self.isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light).previewInterfaceOrientation(.portrait)
    }
}
