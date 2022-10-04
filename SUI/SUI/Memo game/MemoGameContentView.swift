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
                VStack {
                    Text("Memo game")
                        .font(.system(.headline))
                        .foregroundColor(.cyan)
                }
                Spacer()
                
                Menu {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        self.makeChoseThemeButton(theme: theme)
                    }
                } label: {
                    Image(systemName: viewModel.currentThemeImageName)
                }
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
    
    private func makeChoseThemeButton(theme: Theme) -> some View {        
        return VStack(alignment: .center, spacing: 8) {
            Button {
                self.viewModel.changeTheme(theme)
            } label: {
                Image(systemName: viewModel.getThemeImageName(theme: theme))
                    .resizable()
                Text(theme.rawValue.capitalized).font(.system(size: 14, weight: .medium, design: .rounded))
            }
            
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
