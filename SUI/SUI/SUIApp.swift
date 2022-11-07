//
//  SUIApp.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 15.09.2022.
//

import SwiftUI

@main
struct SUIApp: App {
    @StateObject var memoGameViewModel = MGViewModel()
//    @StateObject var drawMojiViewModel = DMDocumentViewModel()
    @StateObject var paletteStore = PaletteStore(name: "Default")
    
    var body: some Scene {
                WindowGroup {
                    NavigationView {
                        List {
                            Text("Choose your game 🎮")
                                .font(.system(.title))
                                .frame(maxWidth: .infinity, alignment: .center)
                            Section {
                                NavigationLink(destination: MGContentView(viewModel: self.memoGameViewModel)) {
                                    self.makeGameSection(name: "MemoGame", 
                                                         description: "Memoji card pair guessing game")
                                }
//                                NavigationLink(destination: DocumentView(viewModel: self.drawMojiViewModel)
//                                    .environmentObject(paletteStore)) { 
//                                        self.makeGameSection(name: "DrawMoji", 
//                                                             description: "Memoji drawing game")
//                                    }
                            }
                            
                        }
                        
                    }
                }
        
        DocumentGroup(newDocument: { DMDocumentViewModel() }) { config in
            DocumentView(viewModel: config.document)
                .environmentObject(paletteStore)
        }
        
    }
    
    private func makeGameSection(name: String, description: String) -> some View {
        VStack(alignment: .leading) {
            Text(name).font(.system(.title))
            Text(description)
        }
    }
}
