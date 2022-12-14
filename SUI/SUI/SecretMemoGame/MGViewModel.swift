//
//  MGViewModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 20.09.2022.
//

import SwiftUI
import ConfettiSwiftUI

final class MGViewModel: ObservableObject {
    typealias Card = MGCardModel<String>
    @Published private var model = createMemoGame(numberOfCardsPairs: 8)
    
    var cards: [Card] {
        model.cards
    }
    
    var numberOfCardsPairs: Int {
        model.numberOfCardsOfSet
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
    
    var isGameEnded: Bool {
        self.model.isGameEnded
    }
    
    private static func createMemoGame(theme: Theme? = nil, numberOfCardsPairs: Int) -> MGModel<String> {
        var emoji: [String] = []
        var currentTheme: Theme
        
        switch theme {
        case .none:
            currentTheme = Theme.allCases.randomElement() ?? .faces
        default:
            currentTheme = theme ?? .faces
        }
        
        emoji = EmojiStock.getEmoji(theme: currentTheme).shuffled()
        return MGModel<String>(numberOfCardsPairs: numberOfCardsPairs,
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
            return SystemImageName.faceThemeIcon
        case .flags:
            return SystemImageName.flagsThemeIcon
        case .vehicles:
            return SystemImageName.vehiclesThemeIcon
        case .animals:
            return SystemImageName.animalsThemeIcon
        case .food:
            return SystemImageName.foodThemeIcon
        case .devices:
            return SystemImageName.devicesThemeIcon
        }
    }
    
    func createNewGame(theme: Theme, numberOfCardsPairs: Int) {
        self.model = MGViewModel.createMemoGame(theme: theme, numberOfCardsPairs: numberOfCardsPairs)
    }
    
    func changeTheme(_ theme: Theme) {
        self.model = MGViewModel.createMemoGame(theme: theme, numberOfCardsPairs: self.model.numberOfCardsOfSet)
    }
    
    func shuffleCards() {
        self.model.shuffleCards()
    }
    
    func onTapCard(card: Card) {
        self.model.choose(card)
    }
}
