//
//  NotificationManager.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import UIKit

class NotificationManager {
    public func checkNotificationPermission() async {
        let isNotDetermined = await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let isNotDetermined = settings.authorizationStatus == .notDetermined
                continuation.resume(returning: isNotDetermined)
            }
        }
        do {
            if isNotDetermined {
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                let isGranted = try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
                if isGranted {
                    await UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } catch(let e) {
            print(e.localizedDescription)
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
#if DEBUG
        print("\(#function) \(Self.self)")
#endif
    }
}
