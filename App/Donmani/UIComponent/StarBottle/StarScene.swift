//
//  CoinScene.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import UIKit
import SpriteKit
import DesignSystem

final class StarScene: SKScene {
    
    var nodeSet: Set<String> = []
    var ground: SKSpriteNode?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.scaleMode = .aspectFit
        self.backgroundColor = .clear
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
    }
    
    public func setGravity(dx: Double, dy: Double) {
        let v = 30.0
        let limit = 10
        var dx = Int(dx * v)
        var dy = Int(dy * v)
        if dx > limit { dx = limit }
        if dx < -limit { dx = -limit }
        if dy > limit { dy = limit }
        if dy < -limit { dy = -limit }
        self.physicsWorld.gravity = CGVector(dx: dx, dy: dy)
    }
    
    deinit {
        print("Deinitialize Star Bottle Scene")
    }
}

extension StarScene: SKPhysicsContactDelegate {
    
}
