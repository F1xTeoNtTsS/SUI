//
//  Cardify.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 13.10.2022.
//

import SwiftUI

struct Cardify: Animatable, ViewModifier {

    var isMatched: Bool
    var rotation: Double
    var borderColor: Color

    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    init(isMatched: Bool, isFaceUp: Bool, borderColor: Color) {
        self.isMatched = isMatched
        self.rotation = isFaceUp ? .zero : Constants.isFaceUpCardRotationDegree
        self.borderColor = borderColor
    }

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Constants.shapeCornerRadius)

            if self.rotation < Constants.rotationDegree {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: Constants.borderLineWidth)
                    .foregroundColor(self.borderColor)
            } else if self.isMatched {
                shape.fill().foregroundColor(.green).opacity(Constants.isMatchedCardOpacity)
            } else {
                shape.foregroundColor(.cyan)
            }
            content.opacity(self.rotation < Constants.rotationDegree ? 1 : .zero)
        }
        .rotation3DEffect(Angle(degrees: rotation), axis: (.zero, 1, .zero))
    }

    private enum Constants {
        static let shapeCornerRadius: CGFloat = 10
        static let borderLineWidth: CGFloat = 4
        static let isMatchedCardOpacity: Double = 0.2
        static let isFaceUpCardRotationDegree: Double = 180
        static let rotationDegree: Double = 90
    }
}

extension View {
    func cardify(isMatched: Bool, isFaceUp: Bool, borderColor: Color) -> some View {
        self.modifier(Cardify(isMatched: isMatched,
                              isFaceUp: isFaceUp,
                              borderColor: borderColor))
    }
}
