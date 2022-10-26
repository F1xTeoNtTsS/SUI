//
//  SUIApp.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import SwiftUI

@main
struct SUIApp: App {
    private let memoGameViewModel = MGViewModel()
    
    @StateObject var drawMojiViewModel = DMDocumentViewModel()
    @StateObject var paletteStore = PaletteStore(name: "Default")
    
    var body: some Scene {
        WindowGroup {
//            MGContentView(viewModel: self.memoGameViewModel)
            DocumentView(viewModel: self.drawMojiViewModel)
                .environmentObject(paletteStore)
        }
    }
}
