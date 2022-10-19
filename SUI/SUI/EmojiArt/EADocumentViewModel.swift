//
//  EADocumentViewModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import SwiftUI

class EADocumentViewModel: ObservableObject {
    typealias Emoji = EAModel.Emoji
    typealias Background = EAModel.Background
    
    @Published private(set) var model: EAModel
    
    init(model: EAModel) {
        self.model = EAModel()
        self.model.addEmoji(content: "👶🏻", at: (x: 100, y: 200), size: 40)
        self.model.addEmoji(content: "👀", at: (x: -100, y: 200), size: 80)
    }
    
    var emojis: [EAModel.Emoji] { self.model.emojis }
    var background: EAModel.Background { self.model.background }
    
    // MARK: - Intents
    
    func setBackground(_ background: Background) {
        self.model.background = background
    }
    
    func addEmoji(content: String, at location: (x: Int, y: Int), size: Int) {
        self.model.addEmoji(content: content, at: (x: location.x, y: location.y), size: size)
    }
    
    func moveEmoji(_ emoji: Emoji, by offset: CGSize) {
        if let index = self.model.emojis.index(matching: emoji) {
            self.model.emojis[index].x = Int(offset.width)
            self.model.emojis[index].y = Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: Emoji, by scale: CGFloat) {
        if let index = self.model.emojis.index(matching: emoji) {
            self.model.emojis[index].size = Int((CGFloat(self.model.emojis[index].size) * scale)
                .rounded(.toNearestOrAwayFromZero))
        }
    }
}
