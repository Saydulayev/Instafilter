//
//  FilterSlider.swift
//  Instafilter
//
//  Created by Saydulayev on 25.12.24.
//

import SwiftUI

struct FilterSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let onChange: () -> Void
    let isEnabled: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Slider(value: $value, in: range)
                .onChange(of: value, onChange)
                .disabled(!isEnabled)
                .opacity(isEnabled ? 1 : 0.5)
        }
    }
}


#Preview {
    MainView()
}
