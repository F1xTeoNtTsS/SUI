//
//  MemoGameCardView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 07.10.2022.
//

import SwiftUI

struct MemoGameCardView: View {
    let card: MemoGameViewModel.Card
    
    private var borderColor: Color {
        var color: Color = .cyan
        if self.card.isMatched {
            color = .green.opacity(0.5)
        }
        if self.card.isNotGuessed {
            color = .red.opacity(0.5)
        }
        return color
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 110-90))
                    .padding(5).opacity(0.5)
                Text(self.card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1)
                        .repeatCount(1), value: card.isMatched)
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
    }
}
