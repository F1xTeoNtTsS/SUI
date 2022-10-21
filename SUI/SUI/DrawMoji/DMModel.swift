//
//  DMModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import Foundation

struct DMModel {
    var background = Background.blank
    var emojis = [Emoji]()
    
    private var uniqueEmojiId = 0
    
    init() { }
    
    struct Emoji: Identifiable, Hashable {
        let content: String
        var x: Int
        var y: Int
        var size: Int
        var id: Int
        
        fileprivate init(content: String, x: Int, y: Int, size: Int, id: Int) {
            self.content = content
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    mutating func addEmoji(content: String, at location: (x: Int, y: Int), size: Int) {
        self.uniqueEmojiId += 1
        self.emojis.append(Emoji(content: content, 
                                 x: location.x, 
                                 y: location.y, 
                                 size: size, 
                                 id: self.uniqueEmojiId))
    }
}
