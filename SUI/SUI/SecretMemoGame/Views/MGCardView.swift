//
//  MemoGameCardView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 07.10.2022.
//

import SwiftUI

struct MGCardView: View {
    let card: MGViewModel.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    private var borderColor: Color {
        var color: Color = .cyan
        if self.card.isMatched {
            color = .green.opacity(Constants.borderColorOpacity)
        }
        if self.card.isNotGuessed {
            color = .red.opacity(Constants.borderColorOpacity)
        }
        return color
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Text(self.card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? Constants.cardMatchedAngleDegree : .zero))
                    .animation(Animation.linear(duration: Constants.animationDuration)
                        .repeatCount(Constants.animationRepeatCount), value: card.isMatched)
                    .font(makeFontForContent(size: geometry.size))
            }
            .cardify(isMatched: self.card.isMatched,
                     isFaceUp: self.card.isFaceUp,
                     borderColor: self.borderColor)
        })
    }
    
    private func makeFontForContent(size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * Constants.fontRatioMultiplier)
    }
    
    private enum Constants {
        static let shapeCornerRadius: CGFloat = 10
        static let borderLineWidth: CGFloat = 4
        static let shapeOpacity: Double = 0
        static let fontRatioMultiplier: Double = 0.7
        static let cardMatchedAngleDegree: Double = 360
        static let animationDuration: Double = 1
        static let animationRepeatCount: Int = 1
        static let borderColorOpacity: Double = 0.5
    }
}
