//
//  FilterPicker.swift
//  Instafilter
//
//  Created by Saydulayev on 25.12.24.
//

import SwiftUI

struct FilterPicker: View {
    @Binding var currentFilter: CIFilter
    let onFilterChange: (CIFilter) -> Void

    var body: some View {
        Section(header: Text("Artistic")) {
            Button("Comic Effect") { onFilterChange(CIFilter.comicEffect()) }
            Button("Bloom") { onFilterChange(CIFilter.bloom()) }
            Button("Color Invert") { onFilterChange(CIFilter.colorInvert()) }
        }
        Section(header: Text("Adjustments")) {
            Button("Saturation") { onFilterChange(CIFilter.colorControls()) }
            Button("Exposure Adjust") { onFilterChange(CIFilter.exposureAdjust()) }
            Button("Hue Adjust") { onFilterChange(CIFilter.hueAdjust()) }
            Button("Gamma Adjust") { onFilterChange(CIFilter.gammaAdjust()) }
        }
        Section(header: Text("Blur & Sharpen")) {
            Button("Gaussian Blur") { onFilterChange(CIFilter.gaussianBlur()) }
            Button("Sharpen") { onFilterChange(CIFilter.sharpenLuminance()) }
        }
        Section(header: Text("Classic")) {
            Button("Crystallize") { onFilterChange(CIFilter.crystallize()) }
            Button("Edges") { onFilterChange(CIFilter.edges()) }
            Button("Pixellate") { onFilterChange(CIFilter.pixellate()) }
            Button("Sepia Tone") { onFilterChange(CIFilter.sepiaTone()) }
            Button("Unsharp Mask") { onFilterChange(CIFilter.unsharpMask()) }
            Button("Vignette") { onFilterChange(CIFilter.vignette()) }
        }
    }
}
