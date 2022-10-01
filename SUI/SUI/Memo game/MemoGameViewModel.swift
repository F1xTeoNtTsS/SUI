//
//  MemoGameViewModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 20.09.2022.
//

import SwiftUI

class MemoGameViewModel: ObservableObject {
    
    static let defaulEmoji = ["🤗", "👽", "🫣", "🤡", "🤖", "😮", "🤠", "😵‍💫"]
    
    @Published private var model: MemoGameModel<String> = createMemoGame()
    
    var cards: Array<MemoGameModel<String>.Card> {
        model.cards
    }
    
    static func createMemoGame() -> MemoGameModel<String> {
        MemoGameModel<String>(numberOfPairsOfCards: 4) { pairIndex in
            defaulEmoji[pairIndex]
        }
    }
    
    func onTapCard(card: MemoGameModel<String>.Card) {
        self.model.choose(card)
    }
}
