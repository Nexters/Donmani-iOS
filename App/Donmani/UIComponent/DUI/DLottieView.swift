//
//  DLottieView.swift
//  Donmani
//
//  Created by 문종식 on 6/2/25.
//

import SwiftUI
import Lottie
import DesignSystem

struct DLottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode

    class AnimationViewContainer: UIView {
        let animationView = LottieAnimationView()
    }

    func makeUIView(context: Context) -> AnimationViewContainer {
        let container = AnimationViewContainer()
        let animation = LottieAnimation.named(name, bundle: .designSystem)
        container.animationView.animation = animation
        container.animationView.loopMode = loopMode
        container.animationView.contentMode = .scaleAspectFill
        container.animationView.backgroundBehavior = .pauseAndRestore
        container.animationView.play()

        container.animationView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(container.animationView)
        NSLayoutConstraint.activate([
            container.animationView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.animationView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            container.animationView.topAnchor.constraint(equalTo: container.topAnchor),
            container.animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }

    func updateUIView(_ uiView: AnimationViewContainer, context: Context) {
        let animation = LottieAnimation.named(name, bundle: .designSystem)
        uiView.animationView.animation = animation
        uiView.animationView.loopMode = loopMode
        uiView.animationView.play()
    }
}
