//
//  DMModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import Foundation

struct DMModel: Codable {
    var background = Background.blank
    var emojis = [Emoji]()
    
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
    
    struct Emoji: Identifiable, Hashable, Codable {
        let content: String
        var x: Int
        var y: Int
        var size: Int
        var id: Int
        
        var isSelected = false
        
        fileprivate init(content: String, x: Int, y: Int, size: Int, id: Int) {
            self.content = content
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    func encodeJson() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    mutating func addEmoji(content: String, at location: (x: Int, y: Int), size: Int) {
        self.uniqueEmojiId += 1
        self.emojis.append(Emoji(content: content, 
                                 x: location.x, 
                                 y: location.y, 
                                 size: size, 
                                 id: self.uniqueEmojiId))
    }
    
    mutating func onTapEmoji(_ emoji: Emoji) {
        if let index = self.emojis.index(matching: emoji) {
            self.emojis[index].isSelected.toggle()
        }
    }
    
    mutating func deleteSelectedEmoji() {
        self.emojis = self.emojis.filter { !$0.isSelected }
    }
}
