//
//  DMDocumentViewModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import SwiftUI
import Combine

final class DMDocumentViewModel: ObservableObject {
    typealias Emoji = DMEmoji
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
    
    var emojis: [DMEmoji] { self.model.emojis }
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
    
    func changeEmojiPosition(_ emoji: Emoji, at location: (x: Int, y: Int)) {
        self.model.changeEmojiPosition(emoji, at: location)
    }
    
    func changeEmoji(action: DMEmoji.Actions) {
        self.model.changeEmoji(action: action)
    }
    
    private var backgroundImageFetchCancellable: AnyCancellable?
    
    private func fetchBackgroundImageDataIfNecessary() {
        self.backgroundImage = nil
        switch self.model.background {
        case .blank:
            break
        case .url(let url):
            self.backgroundImageFetchStatus = .fetching
            self.backgroundImageFetchCancellable?.cancel()
            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                .map { (data, _) in UIImage(data: data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
            
            backgroundImageFetchCancellable = publisher
                .sink { [weak self] image in 
                    self?.backgroundImage = image
                    self?.backgroundImageFetchStatus = (image == nil) ? .failed(url) : .idle
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
