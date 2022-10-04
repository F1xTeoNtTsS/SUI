//
//  EmojiStock.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 03.10.2022.
//

import Foundation

class EmojiStock {
    static func getEmoji(theme: Theme) -> [String] {
        switch theme {
        case .faces:
            return ["🤗", "👽", "🫣", "🤡", "🤖", "😮", "🤠", "😵‍💫"]
        case .flags:
            return ["🏴", "🏳️", "🏁", "🚩", "🏳️‍🌈", "🏴‍☠️", "🇰🇷", "🇮🇩"]
        case .vehicles:
            return ["🚗", "🚕", "🚌", "🚎", "🚑", "🚜", "🚛", "🚚"]
        case .animals:
            return ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]
        case .food:
            return ["🍏", "🍐", "🥑", "🫒", "🥬", "🥔", "🍳", "🍔", "🥨", "🍨", "🍫", "🧉"]
        case .objects:
            return ["⌚️", "💻", "🖨", "📼", "📹", "📟", "📻", "⏰", "🔌"]
        }
    }
}