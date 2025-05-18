//
//  MainNavigationStore+Extension.swift
//  Donmani
//
//  Created by 문종식 on 5/14/25.
//

import ComposableArchitecture
import StoreKit
import UIKit

extension MainNavigationStore {
    func requestAppStoreReview() async {
        if HistoryStateManager.shared.isReadyToRequestAppReview() {
            let connectedScenes = await UIApplication.shared.connectedScenes
            if let windowScene = connectedScenes.map({$0}).first as? UIWindowScene {
                await AppStore.requestReview(in: windowScene)
                HistoryStateManager.shared.setCompleteRequestAppReview()
            }
        }
    }
}
