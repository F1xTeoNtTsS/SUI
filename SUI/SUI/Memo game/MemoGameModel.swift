//
//  MemoGameModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 20.09.2022.
//

public enum Theme: String, CaseIterable {
    case faces, flags, vehicles, animals, food, objects
}

struct MemoGameModel<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var currentTheme: Theme
    private var chosenOneCardIndex: Int?
    
    
    init(numberOfCardsPairs: Int, currentTheme: Theme, createCardContent: (Int) -> CardContent?) {
        self.cards = Array<Card>()
        self.currentTheme = currentTheme
        
        for index in 0..<numberOfCardsPairs {
            if let content = createCardContent(index) {
                cards.append(Card(content: content, id: index * 2))
                cards.append(Card(content: content, id: index * 2 + 1))
            }
            
        }
        self.cards = self.cards.shuffled()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = self.cards.firstIndex(where: { $0.id == card.id }),
           !self.cards[chosenIndex].isFaceUp,
           !self.cards[chosenIndex].isMatched {
            
            if let potentialMatchIndex = self.chosenOneCardIndex {
                if self.cards[chosenIndex].content == self.cards[potentialMatchIndex].content {
                    self.cards[chosenIndex].isMatched = true
                    self.cards[potentialMatchIndex].isMatched = true
                }
                self.chosenOneCardIndex = nil
            } else {
                for index in self.cards.indices {
                    self.cards[index].isFaceUp = false
                }
                self.chosenOneCardIndex = chosenIndex
            }
            self.cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    mutating func changeTheme() {
        
    }
    
    mutating func shuffleCards() {
        self.cards = self.cards.shuffled()
        self.refreshCards()
    }
    
    mutating func refreshCards() {
        for index in self.cards.indices {
            self.cards[index].isFaceUp = false
            self.cards[index].isMatched = false
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        
        var content: CardContent
        var id: Int
    }
}
