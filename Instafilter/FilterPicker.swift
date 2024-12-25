//
//  FilterPicker.swift
//  Instafilter
//
//  Created by Saydulayev on 25.12.24.
//

import SwiftUI


enum FilterType: String, CaseIterable {
    case comicEffect = "Comic Effect"
    case bloom = "Bloom"
    case colorInvert = "Color Invert"
    case sepiaTone = "Sepia Tone"
    case crystallize = "Crystallize"
    case edges = "Edges"
    case pixellate = "Pixellate"
    case gaussianBlur = "Gaussian Blur"
    case sharpen = "Sharpen"
    case vignette = "Vignette"

    var filter: CIFilter {
        switch self {
        case .comicEffect: return CIFilter.comicEffect()
        case .bloom: return CIFilter.bloom()
        case .colorInvert: return CIFilter.colorInvert()
        case .sepiaTone: return CIFilter.sepiaTone()
        case .crystallize: return CIFilter.crystallize()
        case .edges: return CIFilter.edges()
        case .pixellate: return CIFilter.pixellate()
        case .gaussianBlur: return CIFilter.gaussianBlur()
        case .sharpen: return CIFilter.sharpenLuminance()
        case .vignette: return CIFilter.vignette()
        }
    }
}

struct FilterPicker: View {
    @Binding var currentFilter: CIFilter
    let onFilterChange: (CIFilter) -> Void

    var body: some View {
        List {
            Section(header: Text("Filters")) {
                ForEach(FilterType.allCases, id: \.self) { filterType in
                    Button(filterType.rawValue) {
                        onFilterChange(filterType.filter)
                    }
                }
            }
        }
    }
}

