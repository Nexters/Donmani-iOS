//
//  AppDelegate+Extension.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import UIKit
import DNetwork
import FirebaseMessaging

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken {
            HistoryStateManager.shared.setFirebaseToken(token: fcmToken)
            Task {
                try await NetworkManager.NMFcm(service: .shared).registerToken(token: fcmToken)
            }
            print("FCM Token:", fcmToken)
        }
    }
}
