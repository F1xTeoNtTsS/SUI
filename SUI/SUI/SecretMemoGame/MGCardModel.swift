//
//  MGCardModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 18.10.2022.
//

import Foundation

struct MGCardModel<CardContent: Equatable>: Identifiable {
    let content: CardContent
    let id: Int
    var isFaceUp = false
    var isMatched = false
    var isNotGuessed = false
}
