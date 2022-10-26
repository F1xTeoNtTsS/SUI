//
//  PaletteEditor.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 26.10.2022.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette
    
    var body: some View {
        Form {
            self.nameSection
            self.addEmojiSection
            self.removeEmojiSection
        }
        .frame(minWidth: 300, minHeight: 300)
    }
    
    private var nameSection: some View {
        Section {
            TextField("Name", text: $palette.name)
        } header: {
            Text("Name")
        }
    }
    
    @State private var emojisToAdd = ""
    
    private var addEmojiSection: some View {
        Section {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    self.addEmoji(emojis)
                }
        } header: {
            Text("Add Emojis")
        }
    }
    
    private var removeEmojiSection: some View {
        Section(header: Text("Remove Emoji")) {
            let emojis = palette.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            self.removeEmoji(emoji: emoji)
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
    
    private func addEmoji(_ emojis: String) {
        withAnimation { 
            self.palette.emojis = (emojis + self.palette.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    private func removeEmoji(emoji: String) {
        withAnimation {
            self.palette.emojis.removeAll(where: { String($0) == emoji })
        }
    }
}
