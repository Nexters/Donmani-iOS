//
//  UINavigationController+Extension.swift
//  Donmani
//
//  Created by 문종식 on 3/11/25.
//

import UIKit

extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
    static var swipeNavigationPopIsEnabled: Bool = true
    override open func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && UINavigationController.swipeNavigationPopIsEnabled
    }
}
