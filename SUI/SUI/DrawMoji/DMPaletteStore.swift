//
//  DMPaletteStore.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 25.10.2022.
//

import SwiftUI

struct Palette: Identifiable, Codable {
    var name: String
    var emojis: String
    var id: Int
}

class DMPaletteStore: ObservableObject {
    let name: String
    @Published var palettes = [Palette]() {
        didSet {
            self.storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "PaletteStore" + self.name
    }
    
    init(name: String) {
        self.name = name
        self.restoreFromUserDefaults()
        self.makeDefaultPaletteIfNeeded()
    }
    
    // MARK: - Intent
    
    func getPalette(at index: Int) -> Palette {
        let saveIndex = min(max(index, 0), palettes.count - 1)
        return palettes[saveIndex]
    }
    
    func removePalette(at index: Int) -> Int {
        if palettes.count > 1, palettes.indices.contains(index) {
            palettes.remove(at: index)
        }
        return index % palettes.count
    }
    
    func addPalette(name: String, emojis: String? = nil, at index: Int = 0) {
        let unique = (palettes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let palette = Palette(name: name, emojis: emojis ?? "", id: unique)
        let saveIndex = min(max(index, 0), palettes.count)
        
        self.palettes.insert(palette, at: saveIndex)
    }
    
    private func makeDefaultPaletteIfNeeded() {
        if self.palettes.isEmpty {
            Theme.allCases.forEach { theme in
                let emoji = EmojiStock.getEmoji(theme: theme).joined()
                self.addPalette(name: theme.rawValue.capitalized, emojis: emoji)
            }
        }
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(self.palettes), forKey: self.userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: self.userDefaultsKey),
        let decodedPalettes = try? JSONDecoder().decode([Palette].self, from: jsonData) {
            self.palettes = decodedPalettes
        }        
    }
}
