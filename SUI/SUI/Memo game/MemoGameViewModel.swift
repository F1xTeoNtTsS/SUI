//
//  MemoGameViewModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 20.09.2022.
//

import SwiftUI

class MemoGameViewModel: ObservableObject {
    public enum Theme: CaseIterable {
        case flags, vehicles, animals
    }
    
    @Published private var model: MemoGameModel<String> = createMemoGame(numberOfCardsPairs: 8)
    
    var cards: Array<MemoGameModel<String>.Card> {
        model.cards
    }
    
    static func createMemoGame(theme: Theme? = nil, numberOfCardsPairs: Int) -> MemoGameModel<String> {
        let emojiStock = EmojiStock()
        var emoji: [String] = []
        switch theme {
        case .flags:
            emoji = emojiStock.flags
        case .vehicles:
            emoji = emojiStock.vehicles
        case .animals:
            emoji = emojiStock.animals
        case .none:
            emoji = emojiStock.faces
        }
        
        return MemoGameModel<String>(numberOfCardsPairs: numberOfCardsPairs) { pairIndex in
            emoji[pairIndex]
        }
    }
    
    func changeTheme(_ theme: Theme? = nil) {
        self.model = MemoGameViewModel.createMemoGame(theme: theme, numberOfCardsPairs: 8)
    }
    
    func shuffleCards() {
        self.model.shuffleCards()
    }
    
    func onTapCard(card: MemoGameModel<String>.Card) {
        self.model.choose(card)
    }
}
