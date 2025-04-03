//
//  UINavigationController+Extension.swift
//  Donmani
//
//  Created by 문종식 on 3/11/25.
//

import UIKit

extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
    static var swipeNavigationPopIsEnabled: Bool = true
    static var validHandler: (() -> Bool)? = nil
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print(#function)
        if let handler = UINavigationController.validHandler {
            return handler()
        }
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // TODO - Static 클로저로 해결?
        print(#function)
        if !UINavigationController.swipeNavigationPopIsEnabled {
            return false
        }
        return viewControllers.count > 1
    }
}
