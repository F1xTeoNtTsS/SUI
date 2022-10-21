//
//  DMDocumentView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import SwiftUI

struct DMDocumentView: View {
    @ObservedObject var viewModel: DMDocumentViewModel
    
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
            .onDrop(of: [.plainText], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
        }
    }
    
    private let testEmoji = "🤔😶‍🌫️😨🫡🤫😴🤢🤠🥴😈👽💩👻☠️😻😺🎃🤖👾👹👺👍👉🫀🫁🧠🫂👣👁"
    
    var palette: some View {
        DMScrollEmojiView(emojis: testEmoji)
            .font(.system(size: Constants.emojiDefaultFontSize))
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        return providers.loadObjects(ofType: String.self) { string in
            if let emoji = string.first, emoji.isEmoji {
                self.viewModel.addEmoji(content: String(emoji), 
                                        at: converToEmojiCoordinates(location, in: geometry),
                                        size: Int(Constants.emojiDefaultFontSize))
            }
        }
        
    }
    
    private func position(for emoji: DMModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        self.convertFromEmojiCoordinate((emoji.x, emoji.y), in: geometry)
    }
    
    private func converToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(x: location.x - center.x,
                               y: location.y - center.y)
        
        return (Int(location.x), Int(location.y))
    }
    
    private func convertFromEmojiCoordinate(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x), 
            y: center.y + CGFloat(location.y))
    }
    
    private func fontSize(for emoji: DMModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    private enum Constants {
        static let emojiDefaultFontSize: CGFloat = 40
    }
}
