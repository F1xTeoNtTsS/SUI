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
    typealias Emoji = DMEmoji
    typealias Background = DMModel.Background
    
    static var readableContentTypes = [UTType.drawmoji]
    static var writableContentTypes = [UTType.drawmoji]
    
    @Published private(set) var backgroundImage: UIImage?
    @Published private(set) var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
    @Published private(set) var model: DMModel {
        didSet {
            if self.model.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    private var backgroundImageFetchCancellable: AnyCancellable?
    
    init() {
        self.model = DMModel()
    }
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.model = try DMModel(json: data)
            self.fetchBackgroundImageDataIfNecessary()
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    var emojis: [DMEmoji] { self.model.emojis }
    var background: DMModel.Background { self.model.background }
    var hasSelectedEmoji: Bool { self.model.hasSelectedEmoji }
    
    func snapshot(contentType: UTType) throws -> Data {
        try model.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
    
    // MARK: - Intents
    
    func setBackground(_ background: Background, undoManager: UndoManager?) {
        self.undoablyPerform(operation: Constants.setBackgroundOperationName, with: undoManager) { 
            self.model.background = background
        }
    }
    
    func addEmoji(content: String, at location: (x: Int, y: Int), size: Int, undoManager: UndoManager?) {
        self.undoablyPerform(operation: Constants.addEmojiOperationName, with: undoManager) { 
            self.model.addEmoji(content: content, at: (x: location.x, y: location.y), size: size)
        }
    }
    
    func onTapEmoji(_ emoji: Emoji) {
        self.model.onTapEmoji(emoji)
    }
    
    func changeEmojiPosition(_ emoji: Emoji, at location: (x: Int, y: Int), undoManager: UndoManager?) {
        self.undoablyPerform(operation: Constants.changeEmojiPositionOperationName, with: undoManager) { 
            self.model.changeEmojiPosition(emoji, at: location)
        }
    }
    
    func changeEmoji(action: DMEmoji.Actions, undoManager: UndoManager?) {
        self.undoablyPerform(operation: Constants.changeEmojiOperationName, with: undoManager) { 
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
            
            self.backgroundImageFetchCancellable = publisher
                .sink { [weak self] image in 
                    self?.backgroundImage = image
                    self?.backgroundImageFetchStatus = (image == nil) ? .failed(url) : .idle
                }
        case .imageData(let data):
            self.backgroundImage = UIImage(data: data)
        }
    }
    
    private enum Constants {
        static let setBackgroundOperationName = "Set background"
        static let addEmojiOperationName = "Add emoji"
        static let changeEmojiPositionOperationName = "Change emoji position"
        static let changeEmojiOperationName = "Change Size/Delete emoji"
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
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename, conformingTo: .data)
        }
        static var coalescingInterval = 5.0
    }
}

extension UTType {
    static let drawmoji = UTType(exportedAs: "F1xTeoNtTsS.DrawMoji")
}
