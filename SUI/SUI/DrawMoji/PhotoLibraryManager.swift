//
//  PhotoLibraryManager.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 14.11.2022.
//

import SwiftUI
import PhotosUI

struct PhotoLibraryManager: UIViewControllerRepresentable {
    var handlePickedImage: (UIImage?) -> Void
    
    static var isAvailable: Bool {
        return true
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: handlePickedImage)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var handlePickedImage: (UIImage?) -> Void

        init(handlePickedImage: @escaping (UIImage?) -> Void) {
            self.handlePickedImage = handlePickedImage
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            let found = results.map { $0.itemProvider }.loadObjects(ofType: UIImage.self) { [weak self] image in
                self?.handlePickedImage(image)
            }
            if !found {
                handlePickedImage(nil)
            }
        }
    }
}
