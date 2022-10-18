//
//  MGModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 20.09.2022.
//

import Foundation

public enum Theme: String, CaseIterable {
    case faces, flags, vehicles, animals, food, devices
}

struct MGModel<CardContent: Equatable> {
    private(set) var cards: [MGCardModel<CardContent>]
    private(set) var numberOfCardsOfSet: Int
    private(set) var currentTheme: Theme
    private(set) var score: Int
    private(set) var matchedCardsCount: Int
    private(set) var isGameEnded: Bool = false
    
    private var chosenOneCardIndex: Int? {
        get { cards.indices.filter { self.cards[$0].isFaceUp }.oneAndOnly }
        set { self.cards.indices.forEach { self.cards[$0].isFaceUp = ($0 == newValue) }}
    }
    
    private var chosenCardsIndices: [Int] = []
    
    init(numberOfCardsPairs: Int,
         currentTheme: Theme,
         shuffled: Bool = true,
         createCardContent: (Int) -> CardContent?) {
        self.numberOfCardsOfSet = numberOfCardsPairs
        self.cards = []
        self.currentTheme = currentTheme
        
        var indexNumber = 0
        for index in 0..<self.numberOfCardsOfSet {
            if let content = createCardContent(index) {
                for _ in 0...1 {
                    cards.append(MGCardModel(content: content, id: indexNumber))
                    indexNumber += 1
                }
            }
        }
        if shuffled {
            self.cards.shuffle() 
        }
        self.score = 0
        self.matchedCardsCount = 0
    }
    
    mutating func choose(_ card: MGCardModel<CardContent>) {
        self.cards.indices.forEach { self.cards[$0].isNotGuessed = false }
        if let chosenIndex = self.cards.firstIndex(where: { $0.id == card.id }),
           !self.cards[chosenIndex].isFaceUp,
           !self.cards[chosenIndex].isMatched {
            if let potentialMatchIndex = self.chosenOneCardIndex {
                if self.cards[chosenIndex].content == self.cards[potentialMatchIndex].content {
                    self.cards[chosenIndex].isMatched = true
                    self.cards[potentialMatchIndex].isMatched = true
                    self.matchedCardsCount += 2
                    self.score += 2
                } else {
                    self.score -= 2
                    self.cards[chosenIndex].isNotGuessed = true
                    self.cards[potentialMatchIndex].isNotGuessed = true
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                self.chosenOneCardIndex = chosenIndex
            }
        }
        if self.cards.count == self.matchedCardsCount {
            self.isGameEnded = true
        }
    }
    
    mutating func shuffleCards() {
        self.cards.shuffle()
        self.refreshCards()
    }
    
    mutating func refreshCards() {
        for index in self.cards.indices {
            self.cards[index].isFaceUp = false
            self.cards[index].isMatched = false
        }
    }
}

extension Array where Element: Hashable {
    var oneAndOnly: Element? {
        return self.count == 1 ? self.first : nil
    }
}
