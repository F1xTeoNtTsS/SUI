//
//  DMDocumentViewModel.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

final class DMDocumentViewModel: ReferenceFileDocument {
    static var readableContentTypes = [UTType.drawmoji]
    static var writableContentTypes = [UTType.drawmoji]
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.model = try DMModel(json: data)
            self.fetchBackgroundImageDataIfNecessary()
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func snapshot(contentType: UTType) throws -> Data {
        try model.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
    
    typealias Emoji = DMEmoji
    typealias Background = DMModel.Background
    
    @Published private(set) var model: DMModel {
        didSet {
            if model.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    @Published private(set) var backgroundImage: UIImage?
    @Published private(set) var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    
    init() {
        self.model = DMModel()
    }
    
    var emojis: [DMEmoji] { self.model.emojis }
    var background: DMModel.Background { self.model.background }
    var hasSelectedEmoji: Bool { self.model.hasSelectedEmoji }
    
    // MARK: - Intents
    
    func setBackground(_ background: Background, undoManager: UndoManager?) {
        self.undoablyPerform(operation: "Set background", with: undoManager) { 
            self.model.background = background
        }
    }
    
    func addEmoji(content: String, at location: (x: Int, y: Int), size: Int, undoManager: UndoManager?) {
        self.undoablyPerform(operation: "Add emoji", with: undoManager) { 
            self.model.addEmoji(content: content, at: (x: location.x, y: location.y), size: size)
        }
    }
    
    func onTapEmoji(_ emoji: Emoji) {
        self.model.onTapEmoji(emoji)
    }
    
    func changeEmojiPosition(_ emoji: Emoji, at location: (x: Int, y: Int), undoManager: UndoManager?) {
        self.undoablyPerform(operation: "Change emoji position", with: undoManager) { 
            self.model.changeEmojiPosition(emoji, at: location)
        }
    }
    
    func changeEmoji(action: DMEmoji.Actions, undoManager: UndoManager?) {
        self.undoablyPerform(operation: "Change Size/Delete emoji", with: undoManager) { 
            self.model.changeEmoji(action: action)
        }
    }
    
    // MARK: - Undo
    
    private func undoablyPerform(operation: String, with undoManager: UndoManager? = nil, doIt: () -> Void) {
        let oldModel = self.model
        doIt()
        undoManager?.registerUndo(withTarget: self) { myself in
            myself.undoablyPerform(operation: operation, with: undoManager) { 
                myself.model = oldModel
            }
        }
        undoManager?.setActionName(operation)
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

extension UTType {
    static let drawmoji = UTType(exportedAs: "F1xTeoNtTsS.DrawMoji")
}
