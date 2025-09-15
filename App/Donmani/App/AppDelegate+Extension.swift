//
//  AppDelegate+Extension.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import UIKit
import FirebaseMessaging

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken {
            Task {
                let updatedToken = try await userRepository.postUpdateToken(token: fcmToken)
                settings.firebaseToken = updatedToken
#if DEBUG
                print("FCM Token:", updatedToken)
#endif
            }
        }
    }
}
