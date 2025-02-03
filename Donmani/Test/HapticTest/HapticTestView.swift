//
//  HapticTestView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI

struct HapticTestView: View {
    @State var text: String = ""
    var body: some View {
        VStack(spacing: 10) {
            Text("Haptic Test")
                .font(.title)
                .fontWeight(.bold)
            ForEach(
                Feedback.allCases,
                id: \.self
            ) { feedback in
                HapticTextField(
                    placeholder: feedback.title,
                    feedbackStyle: feedback
                )
            }
            TextField(text: $text) {
                Text("Normal")
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    HapticTestView()
}
