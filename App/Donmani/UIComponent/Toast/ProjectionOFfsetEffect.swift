//
//  ProjectionOFfsetEffect.swift
//  Donmani
//
//  Created by 문종식 on 9/22/25.
//

import SwiftUI

public extension View {
    func projectionOffset(x: CGFloat = 0, y: CGFloat = 0) -> some View {
        self.projectionOffset(.init(x: x, y: y))
    }
 
    func projectionOffset(_ translation: CGPoint) -> some View {
        modifier(ProjectionOffsetEffect(translation: translation))
    }
}
 
private struct ProjectionOffsetEffect: GeometryEffect {
    var translation: CGPoint
    var animatableData: CGPoint.AnimatableData {
        get { translation.animatableData }
        set { translation = .init(x: newValue.first, y: newValue.second) }
    }
 
    public func effectValue(size: CGSize) -> ProjectionTransform {
        .init(CGAffineTransform(translationX: translation.x, y: translation.y))
    }
}
