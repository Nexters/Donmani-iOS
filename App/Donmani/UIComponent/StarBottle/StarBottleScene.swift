//
//  StarBottleScene.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import UIKit
import SpriteKit
import DesignSystem

final class StarBottleScene: SKScene {
    
    var nodeSet: Set<String> = []
    var ground: SKSpriteNode?
    var bottleShape: BottleShape = .default
    
    init(size: CGSize, bottleShape: BottleShape) {
        super.init(size: size)
        self.bottleShape = bottleShape
        self.addGroundNodeWithStarBottleShape(
            width: size.width,
            height: size.height,
            shape: bottleShape
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.scaleMode = .aspectFit
        self.backgroundColor = .clear.withAlphaComponent(0.0)
        self.scene?.backgroundColor = .clear.withAlphaComponent(0.0)
        self.scene?.view?.backgroundColor = .clear.withAlphaComponent(0.0)
        self.view?.backgroundColor = .clear.withAlphaComponent(0.0)
        self.inputView?.backgroundColor = .clear.withAlphaComponent(0.0)
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
#if DEBUG
        print("Deinitialize Star Bottle Scene")
#endif
    }
}

extension StarBottleScene: SKPhysicsContactDelegate {
    
}
