//
//  UINavigationController+Extension.swift
//  Donmani
//
//  Created by 문종식 on 3/11/25.
//

import UIKit
import ComposableArchitecture

extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
    public enum TopViewType {
        case others
        case recordEntryPoint
        case recordWriting
    }
    static var swipeNavigationPopIsEnabled: Bool = true
    static var blockSwipe: Bool = false
    static var rootType: RootType = .main
    static var store: StoreOf<NavigationStore>?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print(#function)
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (UINavigationController.rootType == .onboarding && viewControllers.count == 2) {
            return false
        }
        if UINavigationController.blockSwipe {
            return false
        }
        if !UINavigationController.swipeNavigationPopIsEnabled {
            if let store = UINavigationController.store {
                store.send(.blockPopGesture)
            }
            return false
        }
        return viewControllers.count > 1
    }
}
