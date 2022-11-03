//
//  DMEmoji.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 03.11.2022.
//

struct DMEmoji: Identifiable, Hashable, Codable {
    enum Actions: CaseIterable {
        case increaseSize
        case decreaseSize
        case delete
        
        func getSystemImageName() -> String {
            switch self {
            case .increaseSize:
                return "plus.circle"
            case .decreaseSize:
                return "minus.circle"
            case .delete:
                return "trash.circle"
            }
        }
    }
    
    let content: String
    var x: Int
    var y: Int
    var size: Int
    var id: Int
    
    var isSelected = false
    
    init(content: String, x: Int, y: Int, size: Int, id: Int) {
        self.content = content
        self.x = x
        self.y = y
        self.size = size
        self.id = id
    }
}
