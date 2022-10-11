//
//  MemoGameCardView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 07.10.2022.
//

import SwiftUI

struct MemoGameCardView: View {
    let card: MemoGameViewModel.Card
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: Constants.shapeCornerRadius)
                
                if self.card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: Constants.borderLineWidth).foregroundColor(.cyan)
                    Text(self.card.content)
                        .font(makeFontForContent(size: geometry.size))
                } else if card.isMatched {
                    shape.opacity(Constants.shapeOpacity)
                } else {
                    shape.foregroundColor(.cyan)
                }
                
            }
        })
    }
    
    private func makeFontForContent(size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * Constants.fontRatioMultiplier)
    }
    
    private enum Constants {
        static let shapeCornerRadius: CGFloat = 10
        static let borderLineWidth: CGFloat = 4
        static let shapeOpacity: Double = 0
        static let fontRatioMultiplier: Double = 0.8
    }
}
