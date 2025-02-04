//
//  HapticTextField.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
struct HapticTextField: View {
    @State var text: String = ""
    let placeholder: String
    let feedbackStyle: Feedback
    var body: some View {
        TextField(text: $text) {
            Text(placeholder)
        }.onChange(of: text) {
            UIImpactFeedbackGenerator(
                style: feedbackStyle
            )
            .impactOccurred()
        }
        .padding()
    }
}

#Preview {
    HapticTextField(
        placeholder: "Medium",
        feedbackStyle: .medium
    )
}
