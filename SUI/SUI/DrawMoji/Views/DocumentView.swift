//
//  DocumentView.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 19.10.2022.
//

import SwiftUI

struct DocumentView: View {
    @ObservedObject var viewModel: DMDocumentViewModel
    @State var orientation = UIDeviceOrientation.unknown
    @State private var backgroundImageFetchAlertIsShown = false
    @State private var badUrlString: String?
    
    @ScaledMetric var emojiDefaultFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(DMEmoji.Actions.allCases, id: \.self) { action in
                    self.makeActionButton(action: action)
                }
            }
            documentBody
            PaletteChooser(emojiFontSize: self.emojiDefaultFontSize)
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: self.viewModel.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinate((0, 0), in: geometry))
                )
                .gesture(doubleTapToZoom(in: geometry.size))
                if self.viewModel.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2.0)
                }
                ForEach(self.viewModel.emojis) { emoji in
                    Text(emoji.content)
                        .font(.system(size: self.fontSize(for: emoji)))
                        .scaleEffect(zoomScale)
                        .position(self.position(for: emoji, in: geometry))
                        .memofy(isSelected: emoji.isSelected)
                        .onTapGesture {
                            self.viewModel.onTapEmoji(emoji)
                        }
                        .gesture(self.panEmojiGesture(emoji, geometry))
                }
            }
            .clipped()
            .onDrop(of: [.plainText, .url, .image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            .gesture(self.panGesture().simultaneously(with: self.zoomGesture()))
            .alert(isPresented: $backgroundImageFetchAlertIsShown) { 
                self.alert(url: self.badUrlString ?? "")
            }
            .onChange(of: self.viewModel.backgroundImageFetchStatus) { status in
                switch status {
                case .failed(let url):
                    self.badUrlString = url.absoluteString
                    self.backgroundImageFetchAlertIsShown = true
                default:
                    break
                }
            }
            .onReceive(self.viewModel.$backgroundImage) { image in
                if autozoom {
                    self.zoomToFit(image, in: geometry.size)
                }
            }
        }
    }
    
    @State private var autozoom = false
    
    private func makeActionButton(action: DMEmoji.Actions) -> some View {
        Button {
            self.viewModel.changeEmoji(action: action)
        } label: {
            Image(systemName: action.getSystemImageName())
                .font(.largeTitle)
        }
        .padding(.top).padding(.bottom)
        .tint(.cyan)
        .opacity(self.viewModel.hasSelectedEmoji ? 1 : 0)
    }
    
    private func alert(url: String) -> Alert {
        Alert(title: Text("Failed load image from URL"),
              message: Text("URL: \(url)"),
              dismissButton: .default(Text("OK")))
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.autozoom = true
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
                                            size: Int(self.emojiDefaultFontSize / zoomScale))
                }
            }
        }
        return found
    }
    
    private func position(for emoji: DMEmoji, in geometry: GeometryProxy) -> CGPoint {
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
    
    private func fontSize(for emoji: DMEmoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
    // MARK: - Background gestures
    
    @SceneStorage("DocumentView.steadyStatePanOffset")
    private var steadyStatePanOffset = CGSize.zero
    
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
            let hZoom = (image.size.width / size.width) * 1.5
            let vZoom = (image.size.height / size.height) * 1.5
            withAnimation { 
                self.steadyStatePanOffset = .zero
                self.steadyStateZoomScale = min(hZoom, vZoom)
            }
        }
    }
    
    // MARK: - Emojis gestures
    
    private func panEmojiGesture(_ emoji: DMEmoji, _ geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged({ finalDragGestureValue in
                let coordinates = self.converToEmojiCoordinates(finalDragGestureValue.location, in: geometry)
                self.viewModel.changeEmojiPosition(emoji, at: coordinates)
            })
    }
    
    private func tapEmoji(emoji: DMEmoji) -> some Gesture {
        TapGesture(count: 1)
            .onEnded {
                self.viewModel.onTapEmoji(emoji)
            }
    }
}
