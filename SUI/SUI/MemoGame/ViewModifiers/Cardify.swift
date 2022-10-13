//
//  Cardify.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 13.10.2022.
//

import SwiftUI

struct Cardify: ViewModifier {
    
    var isMatched: Bool
    var isFaceUp: Bool
    var borderColor: Color
    
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Constants.shapeCornerRadius)
            
            if self.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: Constants.borderLineWidth)
                    .foregroundColor(self.borderColor)
                content
            } else if self.isMatched {
                shape.fill().foregroundColor(.green).opacity(0.2)
            } else {
                shape.foregroundColor(.cyan)
            }
        }
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
