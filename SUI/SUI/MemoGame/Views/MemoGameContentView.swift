//
//  MemoGameContentView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import SwiftUI

struct MemoGameContentView: View {
    @ObservedObject var viewModel: MemoGameViewModel
    @State private var selectedTheme: Theme
    @State private var numberOfCardsPairs: Int
    
    @State private var newGamePopoverIsShown = false
    @State private var endGameAlertIsShown = false
    
    init(viewModel: MemoGameViewModel) {
        self.viewModel = viewModel
        self.selectedTheme = viewModel.currentTheme
        self.numberOfCardsPairs = viewModel.numberOfCardsPairs
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Memoji")
                        .font(.system(.title)).padding()
                }
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text(viewModel.currentTheme.rawValue.capitalized)
                        .font(.headline).fixedSize()
                    Image(systemName: viewModel.currentThemeImageName).padding().tint(.cyan)
                }
            }
            
            AspectVGrid(items: self.viewModel.cards, aspectRatio: 2/3) { card in
                self.makeCardView(for: card)
            }
            
            
            Spacer(minLength: Constants.spacerMinLength)
            HStack {
                Button {
                    self.newGamePopoverIsShown = true
                } label: {
                    Text("New game").font(.headline)
                }
                .popover(isPresented: $newGamePopoverIsShown) {
                    makeNewGamePopover()
                }
                .buttonStyle(.bordered)
                .tint(.cyan)
                Text("Score: \(self.viewModel.score)").font(.headline).padding().monospacedDigit()
            }
        }
        .foregroundColor(.cyan)
        .padding()
        .font(.largeTitle)
        
        .onChange(of: self.viewModel.isGameEnded) { newValue in
            self.endGameAlertIsShown = newValue
        }
        .alert(isPresented: $endGameAlertIsShown, content: {
            self.makeEndGameAlert()
        })
    }
    
    @ViewBuilder
    private func makeCardView(for card: MemoGameViewModel.Card) -> some View {
        MemoGameCardView(card: card)
            .padding(4)
            .onTapGesture {
                if !card.isMatched && !card.isFaceUp {
                    self.viewModel.onTapCard(card: card)
                }
            }
    }
    
    @ViewBuilder
    private func makeNewGamePopover() -> some View {
        Text("New game").font(.title).padding()
        ScrollView {
            VStack(spacing: 0) {
                Divider()
                Picker("Theme", selection: $selectedTheme) {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        HStack {
                            Text("\(theme.rawValue.capitalized) ").font(.title2).foregroundColor(.cyan)
                            Image(systemName: viewModel.getThemeImageName(theme: theme)).foregroundColor(.cyan)
                        }
                    }
                }
                .pickerStyle(.wheel)
                Text("Selected theme: \(self.selectedTheme.rawValue)").font(.title2)
            }
            Divider()
            VStack(spacing: 0) {
                
                Picker("Pairs", selection: $numberOfCardsPairs) {
                    ForEach(2...15, id: \.self) {
                        Text("\($0)").font(.title2).foregroundColor(.cyan)
                    }
                }
                .pickerStyle(.wheel)
                Text("Number of pairs: \(self.numberOfCardsPairs)").font(.title2)
            }
            Divider()
        }
        Button {
            self.viewModel.createNewGame(theme: self.selectedTheme,
                                         numberOfCardsPairs: self.numberOfCardsPairs)
            self.newGamePopoverIsShown = false
        } label: {
            Text("Start").font(.headline)
        }.padding()
            .buttonStyle(.bordered)
    }
    
    private func makeEndGameAlert() -> Alert {
        Alert(title: Text(self.viewModel.score > 0 ? "You WIN!" : "Game Over!"),
              message: Text("Score: \(self.viewModel.score)"),
              primaryButton: .default(
                Text("Try Again")) {
                    self.viewModel.createNewGame(theme: self.selectedTheme,
                                                 numberOfCardsPairs: self.numberOfCardsPairs)
                },
              secondaryButton: .default(Text("Customize")) {
            self.newGamePopoverIsShown = true
        })
    }
    
    private enum Constants {
        static let minAdaptiveSize: CGFloat = 70
        static let spacerMinLength: CGFloat = 10
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let memoGameViewModel = MemoGameViewModel()
        memoGameViewModel.onTapCard(card: memoGameViewModel.cards.first!)
        return MemoGameContentView(viewModel: memoGameViewModel)
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}
