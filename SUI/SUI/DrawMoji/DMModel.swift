//
//  DMModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import Foundation

struct DMModel: Codable {
    var background = Background.blank
    var emojis = [DMEmoji]()
    
    private var uniqueEmojiId = 0
    var hasSelectedEmoji: Bool {
        for emoji in emojis where emoji.isSelected {
            return true
        }
        return false
    }
    
    init() { }
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(DMModel.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try DMModel(json: data)
    }
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func encodeJson() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    mutating func addEmoji(content: String, at location: (x: Int, y: Int), size: Int) {
        self.uniqueEmojiId += 1
        self.emojis.append(DMEmoji(content: content, 
                                 x: location.x, 
                                 y: location.y, 
                                 size: size, 
                                 id: self.uniqueEmojiId))
    }
    
    mutating func onTapEmoji(_ emoji: DMEmoji) {
        if let index = self.emojis.index(matching: emoji) {
            self.emojis[index].isSelected.toggle()
        }
    }
    
    mutating func changeEmojiPosition(_ emoji: DMEmoji, at location: (x: Int, y: Int)) {
        if let index = self.emojis.index(matching: emoji) {
            self.emojis[index].x = location.x
            self.emojis[index].y = location.y
        }
    }
    
    mutating func changeEmoji(action: DMEmoji.Actions) {
        switch action {
        case .delete:
            self.emojis = self.emojis.filter { !$0.isSelected }
        case .increaseSize:
            _ = self.emojis.indices.filter { self.emojis[$0].isSelected }
                .map { self.emojis[$0].size += 20 }
        case .decreaseSize:
            _ = self.emojis.indices.filter { self.emojis[$0].isSelected }
                .map { self.emojis[$0].size -= 20 }
        }
    }
}
