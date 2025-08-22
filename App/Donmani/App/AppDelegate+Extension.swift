//
//  AppDelegate+Extension.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import UIKit
import FirebaseMessaging
import ComposableArchitecture

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken {
            Task {
                @Dependency(\.settings) var settings
                @Dependency(\.userRepository) var userRepository
                let updatedToken = try await userRepository.postUpdateToken(token: fcmToken)
                settings.firebaseToken = updatedToken
                print("FCM Token:", updatedToken)
            }
        }
    }
}
