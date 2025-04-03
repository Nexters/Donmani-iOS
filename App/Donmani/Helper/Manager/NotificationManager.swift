//
//  NotificationManager.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import UIKit

class NotificationManager {
    public func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions
                ) { granted, _ in
                    if granted {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
        }
    }
    
    public func getNotificationPermissionStatus(handler: @escaping (UNAuthorizationStatus) -> Void){
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            handler(settings.authorizationStatus)
        }
    }
    
    public func registerForRemoteNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    public func unregisterForRemoteNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    deinit {
//        print("Deinit NotificationManager")
    }
}
