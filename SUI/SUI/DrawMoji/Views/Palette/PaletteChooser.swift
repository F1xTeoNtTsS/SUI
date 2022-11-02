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
    
    @EnvironmentObject var store: PaletteStore
    
    @SceneStorage("PaletteChooser.choosenPaletteIndex")
    var choosenPaletteIndex = 0
    
    @State var paletteEditing = false
    @State var paletteManaging = false
    
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
        .tint(.cyan)
        .font(self.emojiFont)
        .contextMenu { contextMenu }
    }
    
    @ViewBuilder
    private var contextMenu: some View {
        AnimatedActionButton(title: "Edit", systemImage: "pencil") { 
            self.paletteEditing = true
        }
        AnimatedActionButton(title: "New", systemImage: "plus.circle") { 
            store.addPalette(name: "New", emojis: "", at: self.choosenPaletteIndex)
            self.paletteEditing = true
        }
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle") { 
            self.choosenPaletteIndex = store.removePalette(at: self.choosenPaletteIndex)
        }
        AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") { 
            self.paletteManaging = true
        }
        goToMenu
    }
    
    private var goToMenu: some View {
        Menu {
            ForEach(self.store.palettes) { palette in
                AnimatedActionButton(title: palette.name.capitalized) { 
                    if let index = self.store.palettes.index(matching: palette) {
                        self.choosenPaletteIndex = index
                    }
                }
            }
        } label: {
            Label("Go To", image: "text.insert")
        }
    }
    
    private func makePaletteView(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollEmojiView(emojis: palette.emojis)
                .font(emojiFont)
        }
        .id(palette.id)
        .transition(self.rollTransition)
        .popover(isPresented: $paletteEditing) { 
            PaletteEditor(palette: $store.palettes[self.choosenPaletteIndex])
        }
        .sheet(isPresented: $paletteManaging) { 
            PaletteManager()
        }
    }
    
    private var rollTransition: AnyTransition {
        AnyTransition.asymmetric(insertion: .offset(x: 0, y: self.emojiFontSize), 
                                 removal: .offset(x: 0, y: -self.emojiFontSize))
    }    
}
