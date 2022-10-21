//
//  DMDocumentViewModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import SwiftUI

final class DMDocumentViewModel: ObservableObject {
    typealias Emoji = DMModel.Emoji
    typealias Background = DMModel.Background
    
    @Published private(set) var model: DMModel {
        didSet {
            if model.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    enum BackgroundImageFetchStatus {
        case idle
        case fetching
    }
    
    init(model: DMModel) {
        self.model = DMModel()
    }
    
    var emojis: [DMModel.Emoji] { self.model.emojis }
    var background: DMModel.Background { self.model.background }
    
    // MARK: - Intents
    
    func setBackground(_ background: Background) {
        self.model.background = background
    }
    
    func addEmoji(content: String, at location: (x: Int, y: Int), size: Int) {
        self.model.addEmoji(content: content, at: (x: location.x, y: location.y), size: size)
    }
    
    func moveEmoji(_ emoji: Emoji, by offset: CGSize) {
        if let index = self.model.emojis.index(matching: emoji) {
            self.model.emojis[index].x = Int(offset.width)
            self.model.emojis[index].y = Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: Emoji, by scale: CGFloat) {
        if let index = self.model.emojis.index(matching: emoji) {
            self.model.emojis[index].size = Int((CGFloat(self.model.emojis[index].size) * scale)
                .rounded(.toNearestOrAwayFromZero))
        }
    }
    
    private func fetchBackgroundImageDataIfNecessary() {
        self.backgroundImage = nil
        switch self.model.background {
        case .blank:
            break
        case .url(let url):
            self.backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInteractive).async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        if self?.model.background == DMModel.Background.url(url) {
                            self?.backgroundImageFetchStatus = .idle
                            self?.backgroundImage = UIImage(data: data)
                        }
                    }
                    
                }
            }
        case .imageData(let data):
            self.backgroundImage = UIImage(data: data)
        }
    }
}
