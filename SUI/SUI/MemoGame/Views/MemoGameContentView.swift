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
                    Text("Memoji")
                        .font(.system(.title)).padding()
                }
                
                Spacer()
                
                Text(viewModel.currentTheme.rawValue.capitalized)
                    .font(.headline).fixedSize()
                Menu {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        self.makeChoseThemeButton(theme: theme)
                    }
                } label: {
                    Image(systemName: viewModel.currentThemeImageName).padding()
                }.tint(.cyan)
            }
            
            AspectVGrid(items: self.viewModel.cards, aspectRatio: 2/3) { card in
                self.makeCardView(for: card)
            }
            Spacer(minLength: Constants.spacerMinLength)
            HStack {
                Button {
                    self.viewModel.createNewGame()
                } label: {
                    Text("New game").font(.headline)
                }
                .buttonStyle(.bordered)
                .tint(.cyan)
                Text("Score: \(self.viewModel.score)").font(.headline).padding().monospacedDigit()
            }
        }
        .foregroundColor(.cyan)
        .padding()
        .font(.largeTitle)
    }
    
    private func makeChoseThemeButton(theme: Theme) -> some View {
        return Button {
            self.viewModel.changeTheme(theme)
        } label: {
            Image(systemName: viewModel.getThemeImageName(theme: theme))
                .resizable()
            Text(theme.rawValue.capitalized)
        }
    }
    
    @ViewBuilder
    private func makeCardView(for card: MemoGameViewModel.Card) -> some View {
        if card.isMatched && !card.isFaceUp {
            Rectangle().opacity(0)
        } else {
            MemoGameCardView(card: card)
                .padding(4)
                .onTapGesture {
                    self.viewModel.onTapCard(card: card)
                }
        }
    }
    
    private enum Constants {
        static let minAdaptiveSize: CGFloat = 70
        static let spacerMinLength: CGFloat = 10
        
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
