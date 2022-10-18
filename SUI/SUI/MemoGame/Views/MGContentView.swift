//
//  MGContentView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import SwiftUI

struct MGContentView: View {
    @ObservedObject var viewModel: MGViewModel
    
    @Namespace private var dealingNamespace
    
    @State private var selectedTheme: Theme
    @State private var numberOfCardsPairs: Int
    @State private var dealt = Set<Int>()
    
    @State private var newGamePopoverIsShown = false
    @State private var endGameAlertIsShown = false
    
    init(viewModel: MGViewModel) {
        self.viewModel = viewModel
        self.selectedTheme = viewModel.currentTheme
        self.numberOfCardsPairs = viewModel.numberOfCardsPairs
    }
    
    var body: some View {
        VStack {
            self.header
            self.gameBody
            //            Spacer(minLength: Constants.spacerMinLength)
            self.footer
        }
        .foregroundColor(.cyan)
        .padding(.horizontal)
        .font(.largeTitle)
        
        .onChange(of: self.viewModel.isGameEnded) { newValue in
            self.endGameAlertIsShown = newValue
        }
        .alert(isPresented: $endGameAlertIsShown, content: {
            self.makeEndGameAlert()
        })
    }
    
    private var header: some View {
        HStack {
            VStack {
                Text("Memoji")
                    .font(.system(.title)).padding()
            }
            Spacer()
            HStack(spacing: 0) {
                Text(viewModel.currentTheme.rawValue.capitalized)
                    .font(.headline).fixedSize()
                ZStack {
                    ForEach(self.viewModel.cards.filter(isUndealt)) { card in
                        MGCardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                            .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                            .zIndex(zIndex(of: card))
                    }
                    .frame(width: 0, height: 0)
                    Image(systemName: viewModel.currentThemeImageName).padding().tint(.cyan)
                }
            }
        }
    }
    
    private func zIndex(of card: MGViewModel.Card) -> Double {
        -Double(self.viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    private var gameBody: some View {
        AspectVGrid(items: self.viewModel.cards, aspectRatio: 2/3) { card in
            if self.isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                MGCardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(self.zIndex(of: card))
                    .onTapGesture {
                        if !card.isMatched && !card.isFaceUp {
                            withAnimation {
                                self.viewModel.onTapCard(card: card)
                            }
                        }
                    }
            }
            
        }
        .onAppear {
            withAnimation {
                self.viewModel.cards.forEach { self.deal($0) }
            }
        }
    }
    
    private var footer: some View {
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
            createNewGame()
            self.newGamePopoverIsShown = false
            
        } label: {
            Text("Start").font(.headline)
        }.padding()
            .buttonStyle(.bordered)
    }
    
    private func makeEndGameAlert() -> Alert {
        Alert(title: Text(self.viewModel.score > 0 ? "You WIN!" : "You LOSE!"),
              message: Text("Score: \(self.viewModel.score)"),
              primaryButton: .default(
                Text("Try Again")) {
                    createNewGame()
                },
              secondaryButton: .default(Text("Customize")) {
            self.newGamePopoverIsShown = true
        })
    }
    
    private func createNewGame() {
        self.dealt.removeAll()
        self.viewModel.createNewGame(theme: self.selectedTheme,
                                     numberOfCardsPairs: self.numberOfCardsPairs)
        
        for card in self.viewModel.cards {
            withAnimation(self.dealAnimation(for: card)) {
                deal(card)
            }
        }
    }
    
    private func dealAnimation(for card: MGViewModel.Card) -> Animation {
        var delay = 0.0
        if let index = self.viewModel.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (0.5 / Double(self.viewModel.cards.count))
        }
        return Animation.easeInOut(duration: 1).delay(delay)
    }
    
    private func deal(_ card: MGViewModel.Card) {
        self.dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: MGViewModel.Card) -> Bool {
        !self.dealt.contains(card.id)
    }
    
    private enum Constants {
        static let minAdaptiveSize: CGFloat = 70
        static let spacerMinLength: CGFloat = 10
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let memoGameViewModel = MGViewModel()
        memoGameViewModel.onTapCard(card: memoGameViewModel.cards.first!)
        return MGContentView(viewModel: memoGameViewModel)
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}
