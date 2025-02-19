//
//  WebView.swift
//  Donmani
//
//  Created by 문종식 on 2/18/25.
//

import SwiftUI
import WebKit

struct InnerWebView: UIViewRepresentable {
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
