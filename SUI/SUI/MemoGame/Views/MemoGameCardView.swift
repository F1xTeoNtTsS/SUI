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
                let shape = RoundedRectangle(cornerRadius: Constants.shapeCornerRadius)
                
                if self.card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: Constants.borderLineWidth)
                        .foregroundColor(self.borderColor)
                    Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 110-90))
                        .padding(5).opacity(0.5)
                    Text(self.card.content)
                        .font(makeFontForContent(size: geometry.size))
                } else if card.isMatched {
                    shape.fill().foregroundColor(.green).opacity(0.2)
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
        static let fontRatioMultiplier: Double = 0.7
    }
}
