//
//  ScrollEmojiView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 20.10.2022.
//

import SwiftUI

struct ScrollEmojiView: View {
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(self.emojis.removingDuplicateCharacters.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { 
                            NSItemProvider(object: emoji as NSString) 
                        }
                }
            }.padding([.trailing, .bottom])
        }.padding([.leading])
    }
}
