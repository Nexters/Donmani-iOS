//
//  AppDelegate.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import UIKit
import DesignSystem

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Load DesignSystem Resource
        DFont.loadFonts()
        
        // Set Notifiacation Center
        UNUserNotificationCenter.current().delegate = self
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//          options: authOptions,
//          completionHandler: { _, _ in }
//        )
//        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("APNs으로 부터 받은 디바이스 토큰:" + deviceToken.description)
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("🔥 디바이스 토큰: \(tokenString)")
        // 파베랑 연결 필요
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("APNs 등록 및 디바이스 토큰 받기 실패:" + error.localizedDescription)
    }
}
