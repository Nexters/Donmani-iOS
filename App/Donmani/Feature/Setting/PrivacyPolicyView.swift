//
//  PrivacyPolicyView.swift
//  Donmani
//
//  Created by 문종식 on 2/17/25.
//

import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    let url = "https://littlemoom.notion.site/bbs-term?pvs=4"
    var body: some View {
        WebView(urlString: url)
    }
}

#Preview {
    PrivacyPolicyView()
}

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
