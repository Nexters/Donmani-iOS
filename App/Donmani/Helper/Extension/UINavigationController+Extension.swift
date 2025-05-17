//
//  UINavigationController+Extension.swift
//  Donmani
//
//  Created by 문종식 on 3/11/25.
//

import UIKit
import ComposableArchitecture

extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
    static var isBlockSwipe: Bool = false
    static var store: StoreOf<MainNavigationStore>?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if UINavigationController.isBlockSwipe {
            UIApplication.shared.endEditing()
            Self.store?.send(.presentCancelBottom)
            return false
        }
        return viewControllers.count > 1
    }
}
