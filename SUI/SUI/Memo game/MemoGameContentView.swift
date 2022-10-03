//
//  MemoGameContentView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import SwiftUI

struct MemoGameContentView: View {
    @ObservedObject var viewModel: MemoGameViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Memo game").font(.system(.title)).foregroundColor(.cyan)
                    .onTapGesture {
                        self.viewModel.shuffleCards()
                        self.viewModel.changeTheme()
                    }
                Spacer()
                
                ForEach(MemoGameViewModel.Theme.allCases, id: \.self) { theme in
                    self.makeChoseThemeButton(theme: theme)
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
    
    private func makeChoseThemeButton(theme: MemoGameViewModel.Theme) -> some View {
        var imageName: String = ""
        var title: String = ""
        var chosenTheme: MemoGameViewModel.Theme
        
        switch theme {
        case .flags:
            chosenTheme = .flags
            imageName = "flag.circle"
            title = "Flags"
        case .vehicles:
            chosenTheme = .vehicles
            imageName = "car.circle"
            title = "Vehicles"
        case .animals:
            chosenTheme = .animals
            imageName = "pawprint.circle"
            title = "Animals"
        }
        return VStack {
            Button {
                self.viewModel.changeTheme(chosenTheme)
            } label: {
                Image(systemName: imageName)
            }
            Text(title).font(.system(size: 14, weight: .medium, design: .rounded))
        }
    }
}

struct CardView: View {
    let card: MemoGameModel<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            
            if self.card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 4).foregroundColor(.cyan)
                Text(self.card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
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
