//
//  MainView.swift
//  Instafilter
//
//  Created by Saydulayev on 25.12.24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import StoreKit
import PhotosUI
import SwiftUI


struct MainView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilters = false
    @State private var errorMessage: String? = nil

    @AppStorage("filterCount") var filterCount = 0
    @AppStorage("hasReviewed") var hasReviewed = false
    @Environment(\.requestReview) var requestReview

    let context = CIContext()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                PhotoPickerView(
                    processedImage: $processedImage,
                    selectedItem: $selectedItem,
                    errorMessage: $errorMessage,
                    loadImage: loadImage
                )

                Spacer()

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                FilterSlidersView(
                    filterIntensity: $filterIntensity,
                    filterRadius: $filterRadius,
                    filterScale: $filterScale,
                    currentFilter: currentFilter,
                    processedImage: processedImage,
                    applyProcessing: applyProcessing
                )

                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(processedImage == nil)

                    Spacer()

                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage)) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        .labelStyle(.iconOnly)
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .sheet(isPresented: $showingFilters) {
                FilterPicker(currentFilter: $currentFilter) { newFilter in
                    setFilter(newFilter)
                    showingFilters = false // Закрытие окна после выбора фильтра
                }
                .presentationDetents([.medium, .large])
            }
        }
    }

    func changeFilter() {
        showingFilters = true
    }

    func loadImage() {
        Task {
            do {
                guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else {
                    throw NSError(domain: "ImageSelection", code: 1, userInfo: [NSLocalizedDescriptionKey: "No image data found."])
                }
                let ciImage = try handleImageSelection(data: imageData)
                currentFilter.setValue(ciImage, forKey: kCIInputImageKey)
                applyProcessing()
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey)
        }

        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }

    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()

        filterCount += 1
        if filterCount >= 20 && !hasReviewed {
            requestReview()
            hasReviewed = true
            filterCount = 0
        }
    }

    func handleImageSelection(data: Data?) throws -> CIImage {
        guard let data = data, let uiImage = UIImage(data: data) else {
            throw NSError(domain: "ImageSelection", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid image data."])
        }
        return CIImage(image: uiImage) ?? CIImage()
    }
}


#Preview {
    MainView()
}
