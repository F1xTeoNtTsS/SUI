//
//  Memofy.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 24.10.2022.
//

import SwiftUI

struct Memofy: ViewModifier {
    
    var isSelected: Bool
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func memofy(isSelected: Bool) -> some View {
        self.modifier(Memofy(isSelected: isSelected))
    }
}
