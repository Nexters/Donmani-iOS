//
//  StarScene+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SpriteKit
import DesignSystem

extension StarScene {
    public static let starTexture = SKTexture(image: DImage(.star).uiImage)
    public func addGroundNode(width: CGFloat, height: CGFloat) {
        self.backgroundColor = .clear
        let nodeSize = CGSize(width: size.width, height: size.width * 1.15)
        let nodeRect = CGRect(origin: .zero, size: nodeSize)
        let nodePath = UIBezierPath(roundedRect: nodeRect, cornerRadius: 65).cgPath
        let roundRectNode = SKShapeNode(path: nodePath)
        roundRectNode.fillColor = .clear
        roundRectNode.strokeColor = .clear
        roundRectNode.lineWidth = 1
        roundRectNode.position = .zero
        
        roundRectNode.physicsBody = SKPhysicsBody(edgeLoopFrom: nodePath)
        roundRectNode.physicsBody?.isDynamic = false
        
        addChild(roundRectNode)
    }
    
    public func addStarNode(width: CGFloat, height: CGFloat) {
        let starNode = SKSpriteNode(texture: Self.starTexture)
        starNode.size = CGSize(width: width/6, height: width/6)
        starNode.position = CGPoint(x: width / 2, y: height / 2)
        starNode.physicsBody = SKPhysicsBody(texture: Self.starTexture, size: starNode.size)
        starNode.physicsBody?.affectedByGravity = true
        starNode.physicsBody?.isDynamic = true
        starNode.physicsBody?.categoryBitMask = 0x1
        
        addChild(starNode)
    }
}
