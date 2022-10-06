//
//  SUIApp.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import SwiftUI

@main
struct SUIApp: App {
    
    private let memoGameViewModel = MemoGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            MemoGameContentView(viewModel: self.memoGameViewModel)
        }
    }
}
