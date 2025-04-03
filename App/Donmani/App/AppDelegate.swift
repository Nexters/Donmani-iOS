//
//  AppDelegate.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import UIKit
import DesignSystem
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Load DesignSystem Resource
        DFont.loadFonts()
        
        // Set Notifiacation Center
        UNUserNotificationCenter.current().delegate = self
        
        // Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("APNs Token:", tokenString)
        HistoryStateManager.shared.setAPNsToken(token: deviceToken)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //        print("APNs 등록 및 디바이스 토큰 받기 실패:" + error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.badge, .sound]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
//        print(response.notification.request.content.title)
//        print(response.notification.request.content.body)
//        print(response.notification.request.content.subtitle)
//        print(response.notification.request.content.badge)
        center.setBadgeCount(0, withCompletionHandler: nil)
        
    }
}
