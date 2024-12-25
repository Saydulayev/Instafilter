//
//  FilterSlidersView.swift
//  Instafilter
//
//  Created by Saydulayev on 25.12.24.
//

import SwiftUI

struct FilterSlidersView: View {
    @Binding var filterIntensity: Double
    @Binding var filterRadius: Double
    @Binding var filterScale: Double
    var currentFilter: CIFilter
    var processedImage: Image?
    let applyProcessing: () -> Void

    var body: some View {
        VStack {
            FilterSlider(
                title: "Intensity",
                value: $filterIntensity,
                range: 0...1,
                onChange: applyProcessing,
                isEnabled: currentFilter.inputKeys.contains(kCIInputIntensityKey) && processedImage != nil
            )
            FilterSlider(
                title: "Radius",
                value: $filterRadius,
                range: 0...1,
                onChange: applyProcessing,
                isEnabled: currentFilter.inputKeys.contains(kCIInputRadiusKey) && processedImage != nil
            )
            FilterSlider(
                title: "Scale",
                value: $filterScale,
                range: 0...1,
                onChange: applyProcessing,
                isEnabled: currentFilter.inputKeys.contains(kCIInputScaleKey) && processedImage != nil
            )
        }
        .padding(.vertical)
    }
}

