//
//  PaletteManager.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 31.10.2022.
//

import SwiftUI

struct PaletteManager: View {
    
    @EnvironmentObject var store: PaletteStore
    @Environment(\.isPresented) var isPresented
    @Environment(\.dismiss) private var dismiss
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<self.store.palettes.count, id: \.self) { paletteIndex in
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[paletteIndex])) { 
                        VStack(alignment: .leading) {
                            Text(store.palettes[paletteIndex].name)
                            Text(store.palettes[paletteIndex].emojis)
                        }
                    }
                }
                .onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newIndexSet in
                    store.palettes.move(fromOffsets: indexSet, toOffset: newIndexSet)
                }
            }
            .navigationTitle("Manage palettes")
            .navigationBarTitleDisplayMode(.inline)
            .dismissable { 
                dismiss()
            }
            .toolbar { 
                ToolbarItem { EditButton() }
            }
            .environment(\.editMode, $editMode)
        }
    }
}
