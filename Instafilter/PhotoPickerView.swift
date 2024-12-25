//
//  PhotoPickerView.swift
//  Instafilter
//
//  Created by Saydulayev on 25.12.24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var processedImage: Image?
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var errorMessage: String?

    let loadImage: () -> Void

    var body: some View {
        PhotosPicker(selection: $selectedItem) {
            if let processedImage {
                processedImage
                    .resizable()
                    .scaledToFit()
            } else {
                ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
            }
        }
        .buttonStyle(.plain)
        .onChange(of: selectedItem, loadImage)
    }
}
