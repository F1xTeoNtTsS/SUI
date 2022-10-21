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
    var body: some Scene {
        WindowGroup {
//            MGContentView(viewModel: self.memoGameViewModel)
            DMDocumentView(viewModel: DMDocumentViewModel(model: DMModel()))
        }
    }
}
