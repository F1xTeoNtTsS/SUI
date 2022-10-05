//
//  MemoGameViewModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 20.09.2022.
//

import SwiftUI

final class MemoGameViewModel: ObservableObject {
    @Published private var model: MemoGameModel<String> = createMemoGame(numberOfCardsPairs: 8)
    
    var cards: Array<MemoGameModel<String>.Card> {
        model.cards
    }
    
    var currentThemeImageName: String {
        self.getThemeImageName(theme: model.currentTheme)
    }
    
    var currentTheme: Theme {
        self.model.currentTheme
    }
    
    var score: Int {
        self.model.score
    }
    
    static func createMemoGame(theme: Theme? = nil, numberOfCardsPairs: Int) -> MemoGameModel<String> {
        var emoji: [String] = []
        var currentTheme: Theme
        
        switch theme {
        case .none:
            currentTheme = Theme.allCases.randomElement() ?? .faces
        default:
            currentTheme = theme ?? .faces
        }
        
        emoji = EmojiStock.getEmoji(theme: currentTheme).shuffled()
        
        return MemoGameModel<String>(numberOfCardsPairs: numberOfCardsPairs,
                                     currentTheme: currentTheme) { pairIndex in
            while pairIndex < emoji.count {
                return emoji[pairIndex]
            }
            return nil
        }
    }
    
    func getThemeImageName(theme: Theme) -> String {
        switch theme {
        case .faces:
            return "face.smiling"
        case .flags:
            return "flag.circle"
        case .vehicles:
            return "car.circle"
        case .animals:
            return "pawprint.circle"
        case .food:
            return "fork.knife.circle"
        case .devices:
            return "tv.circle"
        }
    }
    
    func createNewGame() {
        if let theme = Theme.allCases.randomElement() {
            self.model = MemoGameViewModel.createMemoGame(theme: theme, numberOfCardsPairs: 8)
        }
    }
    
    func changeTheme(_ theme: Theme) {
        self.model = MemoGameViewModel.createMemoGame(theme: theme, numberOfCardsPairs: 8)
    }
    
    func shuffleCards() {
        self.model.shuffleCards()
    }
    
    func onTapCard(card: MemoGameModel<String>.Card) {
        self.model.choose(card)
    }
}
