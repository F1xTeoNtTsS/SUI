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
            scheduledAutosave()
            if model.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    @Published private(set) var backgroundImage: UIImage?
    @Published private(set) var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    init() {
        guard let url = Autosave.url, let autosavedDrawMoji = try? DMModel(url: url) else {
            self.model = DMModel()
            return
        }
        self.model = autosavedDrawMoji
        self.fetchBackgroundImageDataIfNecessary()
    }
    
    var emojis: [DMModel.Emoji] { self.model.emojis }
    var background: DMModel.Background { self.model.background }
    var hasSelectedEmoji: Bool { self.model.hasSelectedEmoji }
    
    private var autosaveTimer: Timer?
    
    private func scheduledAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Autosave.coalescingInterval, repeats: false) { _ in
            self.autosave()
        }
    }
    
    private func autosave() {
        guard let url = Autosave.url else { return }
        self.save(to: url)
    }
    
    private func save(to url: URL) {
        do {
            let data: Data = try self.model.encodeJson()
            print("json = \(String(data: data, encoding: .utf8) ?? "nil")")
            try data.write(to: url)
            print("\(#function) success")
        } catch let encodingError where encodingError is EncodingError {
            print(encodingError.localizedDescription)
        } catch {
            print("\(error)")
        }
    }
    
    // MARK: - Intents
    
    func setBackground(_ background: Background) {
        self.model.background = background
    }
    
    func addEmoji(content: String, at location: (x: Int, y: Int), size: Int) {
        self.model.addEmoji(content: content, at: (x: location.x, y: location.y), size: size)
    }
    
    func onTapEmoji(_ emoji: Emoji) {
        self.model.onTapEmoji(emoji)
    }
    
    func deleteSelectedEmoji() {
        self.model.deleteSelectedEmoji()
    }
    
    private func fetchBackgroundImageDataIfNecessary() {
        self.backgroundImage = nil
        switch self.model.background {
        case .blank:
            break
        case .url(let url):
            self.backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInteractive).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        if self?.model.background == DMModel.Background.url(url) {
                            self?.backgroundImageFetchStatus = .idle
                            self?.backgroundImage = UIImage(data: imageData)
                            if self?.backgroundImage == nil {
                                self?.backgroundImageFetchStatus = .failed(url)
                            }
                        }
                    }
                    
                }
            }
        case .imageData(let data):
            self.backgroundImage = UIImage(data: data)
        }
    }
}

extension DMDocumentViewModel {
    enum BackgroundImageFetchStatus: Equatable {
        case idle
        case fetching
        case failed(URL)
    }
    
    private struct Autosave {
        static let filename = "Autosave.DrawMoji"
        static var url: URL? {
            let documentDerectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDerectory?.appendingPathComponent(filename, conformingTo: .data)
        }
        static var coalescingInterval = 5.0
    }
}
