//
//  MemoGameContentView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import SwiftUI

struct MemoGameContentView: View {
    @ObservedObject var viewModel: MemoGameViewModel
    @State private var showingPopover = false
    @State private var selectedTheme: Theme
    @State private var numberOfCardsPairs: Int
    
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
                
                
//                Menu {
//                    ForEach(Theme.allCases, id: \.self) { theme in
//                        self.makeChoseThemeButton(theme: theme)
//                    }
//                } label: {
//                    Image(systemName: viewModel.currentThemeImageName).padding()
//                }.tint(.cyan)
                
            }
            
            AspectVGrid(items: self.viewModel.cards, aspectRatio: 2/3) { card in
                self.makeCardView(for: card)
            }
            Spacer(minLength: Constants.spacerMinLength)
            HStack {
                Button {
                    self.showingPopover = true
                } label: {
                    Text("New game").font(.headline)
                }
                .popover(isPresented: $showingPopover) {
                    VStack(spacing: 0) {
                        Text("New game").font(.title)
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
                            ForEach(2...10, id: \.self) {
                                Text("\($0)").font(.title2).foregroundColor(.cyan)
                            }
                        }
                        .pickerStyle(.wheel)
                        Text("Number of pairs: \(self.numberOfCardsPairs)").font(.title2)
                    }
                    Divider()
                    
                    Button {
                        self.viewModel.createNewGame(theme: self.selectedTheme,
                                                     numberOfCardsPairs: self.numberOfCardsPairs)
                        self.showingPopover = false
                    } label: {
                        Text("Start").font(.headline)
                    }.padding()
                        .buttonStyle(.bordered)
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
        memoGameViewModel.onTapCard(card: memoGameViewModel.cards.first!)
        return MemoGameContentView(viewModel: memoGameViewModel)
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}
