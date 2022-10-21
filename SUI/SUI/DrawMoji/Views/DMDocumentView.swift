//
//  DMDocumentView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import SwiftUI

struct DMDocumentView: View {
    @ObservedObject var viewModel: DMDocumentViewModel
    @State var orientation = UIDevice.current.orientation
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: self.viewModel.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinate((0, 0), in: geometry))
                )
                .padding()
                .gesture(doubleTapToZoom(in: geometry.size))
                if self.viewModel.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2.0)
                }
                ForEach(self.viewModel.emojis) { emoji in
                    Text(emoji.content)
                        .font(.system(size: self.fontSize(for: emoji)))
                        .scaleEffect(zoomScale)
                        .position(self.position(for: emoji, in: geometry))
                }
            }
            .clipped()
            .onDrop(of: [.plainText, .url, .image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            .gesture(self.panGesture().simultaneously(with: self.zoomGesture()))
        }
    }
    
    private let testEmoji = "🤔😶‍🌫️😨🫡🤫😴🤢🤠🥴😈👽💩👻☠️😻😺🎃🤖👾👹👺👍👉🫀🫁🧠🫂👣👁"
    
    var palette: some View {
        DMScrollEmojiView(emojis: testEmoji)
            .font(.system(size: Constants.emojiDefaultFontSize))
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.viewModel.setBackground(.url(url.imageURL))
        }
        if !found {
            found = providers.loadFirstObject(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    self.viewModel.setBackground(.imageData(data))
                }
            }
        }
        
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    self.viewModel.addEmoji(content: String(emoji), 
                                            at: converToEmojiCoordinates(location, in: geometry),
                                            size: Int(Constants.emojiDefaultFontSize / zoomScale))
                }
            }
        }
        return found
    }
    
    private func position(for emoji: DMModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        self.convertFromEmojiCoordinate((emoji.x, emoji.y), in: geometry)
    }
    
    private func converToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(x: (location.x - self.panOffset.width - center.x) / zoomScale,
                               y: (location.y - self.panOffset.height - center.y) / zoomScale)
        
        return (Int(location.x), Int(location.y))
    }
    
    private func convertFromEmojiCoordinate(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + self.panOffset.width, 
            y: center.y + CGFloat(location.y) * zoomScale + self.panOffset.height)
    }
    
    private func fontSize(for emoji: DMModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    // MARK: - Gestures
    
    @State private var steadyStatePanOffset = CGSize.zero
    @GestureState private var gesturePanOffset = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGesture, gesturePanOffset, _ in
                gesturePanOffset = latestDragGesture.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                zoomToFit(self.viewModel.backgroundImage, in: size)
            }
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latesGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latesGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                self.steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) { 
            if let image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0 {
                let hZoom = image.size.width / size.width
                let vZoom = image.size.height / size.height
                withAnimation { 
                    self.steadyStatePanOffset = .zero
                    self.steadyStateZoomScale = min(hZoom, vZoom)
                }
            }
    }
    
    private enum Constants {
        static let emojiDefaultFontSize: CGFloat = 40
    }
}
