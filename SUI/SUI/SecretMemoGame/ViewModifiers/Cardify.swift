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
        self.rotation = isFaceUp ? 0 : 180
        self.borderColor = borderColor
    }

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Constants.shapeCornerRadius)

            if self.rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: Constants.borderLineWidth)
                    .foregroundColor(self.borderColor)
            } else if self.isMatched {
                shape.fill().foregroundColor(.green).opacity(0.2)
            } else {
                shape.foregroundColor(.cyan)
            }
            content.opacity(self.rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle(degrees: rotation), axis: (0, 1, 0))
    }

    private enum Constants {
        static let shapeCornerRadius: CGFloat = 10
        static let borderLineWidth: CGFloat = 4
    }
}

extension View {
    func cardify(isMatched: Bool, isFaceUp: Bool, borderColor: Color) -> some View {
        self.modifier(Cardify(isMatched: isMatched,
                              isFaceUp: isFaceUp,
                              borderColor: borderColor))
    }
}
