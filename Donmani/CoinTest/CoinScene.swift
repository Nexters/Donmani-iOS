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
        self.physicsWorld.gravity = .init(dx: 0, dy: -2)
        self.scaleMode = .resizeFill
    }
    
    private func createGround(w: CGFloat) {
        let node = SKSpriteNode(color: .blue, size: CGSize(width: w, height: 5))
        node.position = CGPoint(x: w/2, y: 20)
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = false
        self.addChild(node)
        ground = node
    }
    
    public func replaceObject(w: CGFloat) {
        self.backgroundColor = .clear
        let coin = createCoin()
        coin.position = CGPoint(x: w/2, y: w/2)
        self.addChild(coin)
        createGround(w: w)
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
    
    public func shotCoin(w: CGFloat) {
        let coin = createCoin()
        let vector: CGFloat = 20
        coin.position = CGPoint(x: w, y: w)
        coin.physicsBody?.friction = 0.2
        coin.physicsBody?.linearDamping = 0.1
        self.addChild(coin)
        coin.physicsBody?.applyImpulse(CGVector(dx: -vector, dy: vector))
    }
    
    deinit {
        print("Deinitialize CoinScene")
    }
}

extension CoinScene: SKPhysicsContactDelegate {
    
}
