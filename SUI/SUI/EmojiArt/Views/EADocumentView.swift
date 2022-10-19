//
//  EADocumentView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import SwiftUI

struct EADocumentView: View {
    @ObservedObject var viewModel: EADocumentViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.yellow
                ForEach(self.viewModel.emojis) { emoji in
                    Text(emoji.content)
                        .font(.system(size: self.fontSize(for: emoji)))
                        .position(self.position(for: emoji, in: geometry))
                }
            }
        }
        
    }
    
    private let testEmoji = "🤔😶‍🌫️😨🫡🤫😴🤢🤠🥴😈👽💩👻☠️😻😺🎃🤖👾👹👺👍👉🫀🫁🧠🫂👣👁"
    
    var palette: some View {
        ScrollEmojiView(emojis: testEmoji)
            .font(.system(size: Constants.emojiDefaultFontSize))
    }
    
    private func position(for emoji: EAModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        self.convertFromEmojiCoordinate((emoji.x, emoji.y), in: geometry)
    }
    
    private func convertFromEmojiCoordinate(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x), 
            y: center.y + CGFloat(location.y))
    }
    
    private func fontSize(for emoji: EAModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private enum Constants {
        static let emojiDefaultFontSize: CGFloat = 40
    }
}

struct ScrollEmojiView: View {
    let emojis: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(self.emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                }
            }.padding([.leading, .trailing, .bottom])
        }.padding([.leading, .trailing])
    }
}
