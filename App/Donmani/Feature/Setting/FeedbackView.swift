//
//  PrivacyPolicyView.swift
//  Donmani
//
//  Created by 문종식 on 2/17/25.
//

import SwiftUI
struct FeedbackView: View {
    let url = "https://forms.gle/G32u2RTKjHM8Fwef7"
    var body: some View {
        InnerWebView(urlString: url)
    }
}

#Preview {
    FeedbackView()
}

