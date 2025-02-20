//
//  StarScene+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SpriteKit
import SwiftUI
import DesignSystem

extension StarScene {
    public static let starShapeTexture = SKTexture(image: DImage(.starShape).uiImage)
    public static let starDoubleHighlighterTexture = SKTexture(image: DImage(.starDoubleHighlighter).uiImage)
    public static let starInnerShadow = SKTexture(image: DImage(.starInnerShadow).uiImage)
    
    public func addGroundNode(width: CGFloat, height: CGFloat) {
        self.backgroundColor = .clear
        let nodeSize = CGSize(width: size.width, height: size.width * 1.15)
        let nodeRect = CGRect(origin: .zero, size: nodeSize)
        let nodePath = UIBezierPath(roundedRect: nodeRect, cornerRadius: 65).cgPath
        let roundRectNode = SKShapeNode(path: nodePath)
        roundRectNode.fillColor = .clear
        roundRectNode.strokeColor = .clear
        roundRectNode.lineWidth = 1
        roundRectNode.zPosition = 1
        roundRectNode.position = .zero
        
        roundRectNode.physicsBody = SKPhysicsBody(edgeLoopFrom: nodePath)
        roundRectNode.physicsBody?.isDynamic = false
        
        addChild(roundRectNode)
    }
    
    public func createNewStarNode(
        width: CGFloat,
        height: CGFloat,
        record: Record
    ) {
        let starSize = width/6
        let position = CGPoint(
            x: width / 2,
            y: height - starSize * 1.7
        )
        createStarNode(
            starSize: starSize,
            position: position,
            record: record
        )
    }
    
    public func createInitStarNode(
        width: CGFloat,
        height: CGFloat,
        record: Record
    ) {
        
        if nodeSet.contains(record.date) {
            return
        }
        nodeSet.insert(record.date)
        let starSize = width/6
        let position = CGPoint(
            x: (starSize / 2) + starSize * CGFloat((nodeSet.count - 1) % 6),
            y: (starSize / 2) + starSize * CGFloat((nodeSet.count - 1) / 6) + starSize
        )
        createStarNode(
            starSize: starSize,
            position: position,
            record: record
        )
    }
    
    private func createStarNode(
        starSize: CGFloat,
        position: CGPoint,
        record: Record
    ) {
        let size = CGSize(width: starSize - 1, height: starSize - 1)
        let starNode = SKSpriteNode(texture: Self.starShapeTexture)
        starNode.size = size
        starNode.position = position
        starNode.physicsBody = SKPhysicsBody(texture: starNode.texture!, size: starNode.size)
        starNode.physicsBody?.affectedByGravity = true
        
        let colors = record.contents?.map{ $0.category.color } ?? [DColor.emptyColor]
        addGradientColor(node: starNode, colors: colors)
        addHighligerTexture(node: starNode, size: size)
        addInnerShadowTexture(node: starNode, size: size)
        starNode.zPosition = 2
        addChild(starNode)
    }
    
    func addGradientColor(node: SKSpriteNode, colors: [Color]) {
        if colors.count == 1 {
            node.color = UIColor(colors[0])
            node.colorBlendFactor = 1.0
        } else if colors.count == 2 {
            let uniforms = [
                SKUniform(name: "startColor", vectorFloat4: SKColor(colors[0]).vec4()),
                SKUniform(name: "endColor", vectorFloat4: SKColor(colors[1]).vec4())
            ]
            let shader = SKShader(fileNamed: "Gradient.fsh")
            shader.uniforms = uniforms
            node.shader = shader
        }
    }
    
    func addHighligerTexture(node: SKSpriteNode, size: CGSize) {
        let starDoubleHighlighterTexture = SKSpriteNode(texture: Self.starDoubleHighlighterTexture)
        starDoubleHighlighterTexture.zPosition = 2
        starDoubleHighlighterTexture.size = size
        node.addChild(starDoubleHighlighterTexture)
    }
    
    func addInnerShadowTexture(node: SKSpriteNode, size: CGSize) {
        let starInnerShadowTexture = SKSpriteNode(texture: Self.starInnerShadow)
        starInnerShadowTexture.zPosition = 1
        starInnerShadowTexture.size = size
        node.addChild(starInnerShadowTexture)
    }
}

extension SKColor {
    func vec4() -> vector_float4
    {
        var r:CGFloat = 0.0
        var g:CGFloat = 0.0
        var b:CGFloat = 0.0
        var a:CGFloat = 0.0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return vector_float4(Float(r), Float(g), Float(b), Float(a))
    }
}
