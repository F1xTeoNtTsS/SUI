//
//  MemoGameModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 20.09.2022.
//

struct MemoGameModel<CardContent: Equatable> {
    private(set) var cards: Array<Card>
    private var choosenOneCard: Card?
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        self.cards = Array<Card>()
        
        for index in 0..<numberOfPairsOfCards {
            let content = createCardContent(index)
            cards.append(Card(content: content, id: index * 2))
            cards.append(Card(content: content, id: index * 2 + 1))
        }
        self.cards = self.cards.shuffled()
    }
    
    mutating func choose(_ card: Card) {
        if let index = self.cards.firstIndex(where: { $0.id == card.id }) {
            self.cards[index].isFaceUp = !self.cards[index].isFaceUp
            
            if choosenOneCard == nil {
                self.choosenOneCard = self.cards[index]
            } else {
                if choosenOneCard?.content == self.cards[index].content {
                    self.removeCards(card: self.cards[index])
                }
            }
            
        }
    }
    
    mutating func removeCards(card: Card) {
        self.cards.removeAll(where: { $0.content == card.content })
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        
        var content: CardContent
        var id: Int
    }
}
