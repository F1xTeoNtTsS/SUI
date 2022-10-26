//
//  PaletteChooser.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 25.10.2022.
//

import SwiftUI

struct PaletteChooser: View {
    var emojiFontSize: CGFloat = 40
    var emojiFont: Font { .system(size: emojiFontSize) }
    
    @EnvironmentObject var store: DMPaletteStore
    @State var choosenPaletteIndex = 0
    
    var body: some View {
        HStack {
            self.paletteControlButton
            self.makePaletteView(for: self.store.palettes[choosenPaletteIndex])
        }
        .padding([.leading, .bottom])
        .clipped()
    }
    
    private var paletteControlButton: some View {
        Button {
            withAnimation { 
                self.choosenPaletteIndex = (choosenPaletteIndex + 1) % store.palettes.count
            }
            
        } label: {
            Image(systemName: "paintpalette")
        }
        .font(self.emojiFont)
    }
    
    private func makePaletteView(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            DMScrollEmojiView(emojis: palette.emojis)
                .font(emojiFont)
        }
        .id(palette.id)
        .transition(self.rollTransition)
    }
    
    private var rollTransition: AnyTransition {
        AnyTransition.asymmetric(insertion: .offset(x: 0, y: self.emojiFontSize), 
                                 removal: .offset(x: 0, y: -self.emojiFontSize))
    }    
}
