//
//  SUIApp.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import SwiftUI

@main
struct SUIApp: App {
    @StateObject var paletteStore = PaletteStore(name: "Default")
    
    var body: some Scene {
        DocumentGroup(newDocument: { DMDocumentViewModel() }) { config in
            DocumentView(viewModel: config.document)
                .toolbarRole(.navigationStack)
                .environmentObject(paletteStore)
        }
    }
}
