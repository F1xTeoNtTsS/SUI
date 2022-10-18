//
//  MemoGameTests.swift
//  MemoGameTests
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import XCTest
@testable import SUI

class MemoGameTests: XCTestCase {
    
    var model: MGModel<String>!
    
    override func setUp() {
        let emoji = EmojiStock.getEmoji(theme: .faces)
        
        self.model = MGModel<String>(numberOfCardsPairs: 2,
                                     currentTheme: .faces, shuffled: false) { pairIndex in
            while pairIndex < emoji.count {
                return emoji[pairIndex]
            }
            return nil
        }
        print(model.cards)
    }
    
    override func tearDown() {
        model = nil
      }

    func testInitialGameSettings() {
        XCTAssertEqual(model.cards.count, 4)
        XCTAssertEqual(model.numberOfCardsOfSet, 2)
        XCTAssertEqual(model.currentTheme, .faces)
        XCTAssertEqual(model.score, 0)
        XCTAssertEqual(model.matchedCardsCount, 0)
        XCTAssertFalse(model.isGameEnded)
    }
    
    func testChooseCard() {
        XCTAssertFalse(model.cards.first!.isFaceUp)
        
        model.choose(model.cards.first!)
        XCTAssertTrue(model.cards.first!.isFaceUp)
    }
    
    func testChooseEqualCards() {
        XCTAssertFalse(model.cards[0].isMatched)
        XCTAssertFalse(model.cards[1].isMatched)
        XCTAssertEqual(model.matchedCardsCount, 0)
        
        model.choose(model.cards[0])
        XCTAssertFalse(model.cards[0].isMatched)
        XCTAssertEqual(model.matchedCardsCount, 0)
        
        model.choose(model.cards[1])
        XCTAssertTrue(model.cards[0].isMatched)
        XCTAssertTrue(model.cards[1].isMatched)
        XCTAssertEqual(model.matchedCardsCount, 2)
    }
    
    func testChooseDifferentCards() {
        XCTAssertFalse(model.cards[0].isNotGuessed)
        XCTAssertFalse(model.cards[0].isMatched)
        XCTAssertFalse(model.cards[2].isNotGuessed)
        XCTAssertFalse(model.cards[2].isMatched)
        
        model.choose(model.cards[0])
        XCTAssertFalse(model.cards[0].isMatched)
        XCTAssertFalse(model.cards[0].isNotGuessed)
        
        model.choose(model.cards[2])
        XCTAssertFalse(model.cards[0].isMatched)
        XCTAssertFalse(model.cards[1].isMatched)
        XCTAssertTrue(model.cards[0].isNotGuessed)
        XCTAssertTrue(model.cards[2].isNotGuessed)
    }
    
    func testFaceDownTwoCardsAfterThirdCardChoose() {
        XCTAssertFalse(model.cards[0].isFaceUp)
        XCTAssertFalse(model.cards[1].isFaceUp)
        XCTAssertFalse(model.cards[2].isFaceUp)
        
        model.choose(model.cards[0])
        XCTAssertTrue(model.cards[0].isFaceUp)
        XCTAssertFalse(model.cards[1].isFaceUp)
        XCTAssertFalse(model.cards[2].isFaceUp)
        
        model.choose(model.cards[1])
        XCTAssertTrue(model.cards[0].isFaceUp)
        XCTAssertTrue(model.cards[1].isFaceUp)
        XCTAssertFalse(model.cards[2].isFaceUp)
        
        model.choose(model.cards[2])
        XCTAssertFalse(model.cards[0].isFaceUp)
        XCTAssertFalse(model.cards[1].isFaceUp)
        XCTAssertTrue(model.cards[2].isFaceUp)
    }
    
    func testChangeScoreAfterChoosingCards() {
        XCTAssertEqual(model.score, 0)
        XCTAssertFalse(model.isGameEnded)
        
        // Different cards
        model.choose(model.cards[0])
        model.choose(model.cards[2])
        XCTAssertEqual(model.score, -2)
        
        // Equal cards
        model.choose(model.cards[1])
        model.choose(model.cards[0])
        XCTAssertEqual(model.score, 0)
        
        // Equal cards
        model.choose(model.cards[2])
        model.choose(model.cards[3])
        XCTAssertEqual(model.score, 2)
        XCTAssertTrue(model.isGameEnded)
    }
    
    func testEndGameAfterChooseAllEqualCards() {
        XCTAssertFalse(model.isGameEnded)
        
        // Different cards
        model.choose(model.cards[0])
        model.choose(model.cards[1])
        model.choose(model.cards[2])
        model.choose(model.cards[3])
        XCTAssertTrue(model.isGameEnded)
    }
}
