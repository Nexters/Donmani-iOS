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
        let title = notification.request.content.title
        var value = DayType.today.title
        if title.contains(DayType.yesterday.title) {
            value = DayType.yesterday.title
        }
        GA.Receive(event: .notificationReceive).send(parameters: [.notificationType: value])
        return [.badge, .sound, .banner]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let title = response.notification.request.content.title
        let key = "destination"
        var value = DayType.today.title
        if title.contains(DayType.yesterday.title) {
            value = DayType.yesterday.title
        }
        GA.Open(event: .notificationOpen).send(parameters: [.notificationType: value])
        NotificationCenter.default.post(
            name: .didReceivePushNavigation,
            object: nil,
            userInfo: [key: value]
        )
        center.setBadgeCount(0, withCompletionHandler: nil)
        
    }
    
}

extension Notification.Name {
    static let didReceivePushNavigation = Notification.Name("didReceivePushNavigation")
}
