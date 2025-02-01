//
//  CoinScene.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import UIKit
import SpriteKit

final class CoinScene: SKScene {
    
    var ground: SKSpriteNode?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        setGravity(dx: 0.0, dy: -0.2)
        self.scaleMode = .resizeFill
    }
    
    private func createGround(width: CGFloat, height: CGFloat) {
        let bottom = SKSpriteNode(color: .blue, size: CGSize(width: width, height: 5))
        bottom.position = CGPoint(x: width/2, y: 20)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottom.size)
        bottom.physicsBody?.isDynamic = false
        self.addChild(bottom)
        
        let top = SKSpriteNode(color: .blue, size: CGSize(width: width, height: 5))
        top.position = CGPoint(x: width/2, y: height - 120)
        top.physicsBody = SKPhysicsBody(rectangleOf: top.size)
        top.physicsBody?.isDynamic = false
        self.addChild(top)
        
        let left = SKSpriteNode(color: .blue, size: CGSize(width: 5, height: height))
        left.position = CGPoint(x: 20, y: height/2)
        left.physicsBody = SKPhysicsBody(rectangleOf: left.size)
        left.physicsBody?.isDynamic = false
        self.addChild(left)
        
        let right = SKSpriteNode(color: .blue, size: CGSize(width: 5, height: height))
        right.position = CGPoint(x: width - 20, y: height/2)
        right.physicsBody = SKPhysicsBody(rectangleOf: right.size)
        right.physicsBody?.isDynamic = false
        self.addChild(right)
        
//        ground = top
    }
    
    public func replaceObject(width: CGFloat, height: CGFloat) {
        self.backgroundColor = .clear
//        let coin = createCoin()
//        coin.position = CGPoint(x: width/2, y: width/2)
//        self.addChild(coin)
        createGround(width: width, height: height)
    }
    
    private func createCoin() -> SKNode {
        let size: CGFloat = 30
        let node = SKShapeNode(circleOfRadius: size)
        node.fillColor = .orange
        node.strokeColor = .clear
        node.physicsBody = SKPhysicsBody(circleOfRadius: size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.restitution = 0.8
        return node
    }
    
    public func shotCoin(width: CGFloat, height: CGFloat) {
        let coin = createCoin()
        let vector: CGFloat = 20
        coin.position = CGPoint(x: width/2, y: height/2)
        coin.physicsBody?.friction = 0.2
        coin.physicsBody?.linearDamping = 0.1
        self.addChild(coin)
        coin.physicsBody?.applyImpulse(CGVector(dx: -vector, dy: vector))
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
        print("Deinitialize CoinScene")
    }
}

extension CoinScene: SKPhysicsContactDelegate {
    
}
