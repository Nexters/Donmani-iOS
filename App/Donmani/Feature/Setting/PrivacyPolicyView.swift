//
//  PrivacyPolicyView.swift
//  Donmani
//
//  Created by 문종식 on 2/17/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    let url = "https://littlemoom.notion.site/bbs-term?pvs=4"
    var body: some View {
        InnerWebView(urlString: url)
    }
}

#Preview {
    PrivacyPolicyView()
}
