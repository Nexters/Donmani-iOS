//
//  StarScene+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/9/25.
//

import SpriteKit
import SwiftUI
import DesignSystem

extension StarBottleScene {
    public static let starShapeTexture = SKTexture(image: DImage(.starShape).uiImage)
    public static let starDoubleHighlighterTexture = SKTexture(image: DImage(.starDoubleHighlighter).uiImage)
    public static let starInnerShadow = SKTexture(image: DImage(.starInnerShadow).uiImage)
    
    public func addGroundNodeWithStarBottleShape(
        width: CGFloat,
        height: CGFloat,
        shape: BottleShape
    ) {
        self.backgroundColor = .clear
        let nodeSize = CGSize(width: size.width, height: size.height)
        let texture = SKTexture(image: DImage(shape.imageAsset).uiImage)
        let node = SKSpriteNode(texture: texture)
        node.size = nodeSize
        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        node.physicsBody?.isDynamic = false
        node.position = CGPoint(x: size.width / 2, y: size.height / 2)
        node.alpha = 1.0
        addChild(node)
    }
    
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
    
    
    public func createInitStarNode(
        width: CGFloat,
        height: CGFloat,
        record: Record,
        index: Int
    ) {
        switch bottleShape {
        case .default:
            createInitStarNodeDefault(width: width, height: height, record: record, index: index)
        case .bead:
            createInitStarNodeBeads(width: width, height: height, record: record, index: index)
        case .heart:
            createInitStarNodeFuzzy(width: width, height: height, record: record, index: index)
        }
    }
    public func createNewStarNode(
        width: CGFloat,
        height: CGFloat,
        record: Record
    ) {
        switch bottleShape {
        case .default:
            createNewStarNodeDefault(width: width, height: height, record: record)
        case .bead:
            createNewStarNodeBeads(width: width, height: height, record: record)
        case .heart:
            createNewStarNodeFuzzy(width: width, height: height, record: record)
        }
    }
    
    // Default
    public func createNewStarNodeDefault(
        width: CGFloat,
        height: CGFloat,
        record: Record
    ) {
        let starSize = width / 5
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
    // Default
    public func createInitStarNodeDefault(
        width: CGFloat,
        height: CGFloat,
        record: Record,
        index: Int
    ) {
        // Test Code
//        var record = record
//        record.date = "Test\(index)"
        
        let starCountInLine: Int = 5
        let starSize = width / CGFloat(starCountInLine)
        var lineIndex = CGFloat(index / 9) * 2
        let subIndex = index % 9
        
        var position: CGPoint = CGPoint(
            x: (starSize / 2) + starSize * CGFloat(subIndex % starCountInLine),
            y: (starSize / 2) + lineIndex * starSize * (2.0 / 3.0)
        )
        if subIndex > 3 {
            lineIndex += 1
            position.y = (starSize / 2) + lineIndex * starSize * (2.0 / 3.0)
        } else {
            position.x += (width - 4 * starSize) / 2
        }
        
        createStarNode(
            starSize: starSize,
            position: position,
            record: record
        )
    }
    
    // Beads
    public func createInitStarNodeBeads(
        width: CGFloat,
        height: CGFloat,
        record: Record,
        index: Int
    ) {
        let starCountInLine: Int = 5
        let starSize: CGFloat = width / CGFloat(starCountInLine)
        var position: CGPoint = .zero
        if (index < 4) {
            let startPoint: CGFloat = (width / 2.0) - ((starSize - 5) * 1.5)
            position = CGPoint(
                x: startPoint + CGFloat(index) * (starSize - 5),
                y: starSize
            )
        } else if (index < 7) {
            let startPoint: CGFloat = (width / 2.0) - (starSize - 5)
            position = CGPoint(
                x: startPoint + CGFloat(index - 4) * (starSize - 5),
                y: 1.6 * starSize
            )
        } else if (index < 11) {
            let startPoint: CGFloat = (width / 2.0) - ((starSize - 5) * 1.5)
            position = CGPoint(
                x: startPoint + CGFloat(index - 7) * (starSize - 5),
                y: 2.2 * starSize
            )
        } else if (index < 16) {
            let startPoint: CGFloat = (width / 2.0) - (2 * (starSize - 5))
            position = CGPoint(
                x: startPoint + CGFloat(index - 11) * (starSize - 5),
                y: 2.8 * starSize
            )
        } else if (index < 20) {
            let startPoint: CGFloat = (width / 2.0) - ((starSize - 5) * 1.5)
            position = CGPoint(
                x: startPoint + CGFloat(index - 16) * (starSize - 5),
                y: 3.4 * starSize
            )
        } else if (index < 25) {
            let startPoint: CGFloat = (width / 2.0) - (2 * (starSize - 5))
            position = CGPoint(
                x: startPoint + CGFloat(index - 20) * (starSize - 5),
                y: 4.0 * starSize
            )
        } else if (index < 29) {
            let startPoint: CGFloat = (width / 2.0) - ((starSize - 5) * 1.5)
            position = CGPoint(
                x: startPoint + CGFloat(index - 25) * (starSize - 5),
                y: 4.6 * starSize
            )
        } else {
            let startPoint: CGFloat = (width / 2.0) - (starSize - 5)
            position = CGPoint(
                x: startPoint + CGFloat(index - 29) * (starSize - 5),
                y: 5.2 * starSize
            )
        }
        
        createStarNode(
            starSize: starSize,
            position: position,
            record: record
        )
    }
    
    // Beads
    public func createNewStarNodeBeads(
        width: CGFloat,
        height: CGFloat,
        record: Record
    ) {
        let starSize = width / 5
        let position = CGPoint(
            x: width / 2,
            y: 5.2 * starSize
        )
        createStarNode(
            starSize: starSize,
            position: position,
            record: record
        )
    }
    
    // Fuzzy
    public func createInitStarNodeFuzzy(
        width: CGFloat,
        height: CGFloat,
        record: Record,
        index: Int
    ) {
        let starCountInLine: Int = 5
        let starSize: CGFloat = width / CGFloat(starCountInLine)
        let yGap = starSize * 0.9
        let gap: CGFloat = (starSize * 0.8)
        var position: CGPoint = .zero
        if (index < 3) {
            let startPoint: CGFloat = (width / 2.0) - gap
            position = CGPoint(
                x: startPoint + CGFloat(index) * gap,
                y: yGap
            )
        } else if (index < 5) {
            let startPoint: CGFloat = (width / 2.0) - (gap * 0.5)
            position = CGPoint(
                x: startPoint + CGFloat(index - 3) * gap,
                y: 1.6 * yGap
            )
        } else if (index < 8) {
            let startPoint: CGFloat = (width / 2.0) - gap
            position = CGPoint(
                x: startPoint + CGFloat(index - 5) * gap,
                y: 2.2 * yGap
            )
        } else if (index < 12) {
            let startPoint: CGFloat = (width / 2.0) - (gap * 1.5)
            position = CGPoint(
                x: startPoint + CGFloat(index - 8) * gap,
                y: 2.8 * yGap
            )
        } else if (index < 17) {
            let startPoint: CGFloat = (width / 2.0) - (gap * 2.0)
            position = CGPoint(
                x: startPoint + CGFloat(index - 12) * gap,
                y: 3.4 * yGap
            )
        } else if (index < 23) {
            let startPoint: CGFloat = (width / 2.0) - (gap * 2.5)
            position = CGPoint(
                x: startPoint + CGFloat(index - 17) * gap,
                y: 4.0 * yGap
            )
        } else if (index < 28) {
            let startPoint: CGFloat = (width / 2.0) - (gap * 2.0)
            position = CGPoint(
                x: startPoint + CGFloat(index - 23) * gap,
                y: 4.6 * yGap
            )
        } else {
            let startPoint: CGFloat = (width / 2.0) - (gap * 1.5)
            position = CGPoint(
                x: startPoint + CGFloat(index - 28) * gap,
                y: 5.2 * yGap
            )
        }
        
        createStarNode(
            starSize: starSize,
            position: position,
            record: record
        )
    }
    // Fuzzy
    public func createNewStarNodeFuzzy(
        width: CGFloat,
        height: CGFloat,
        record: Record
    ) {
        let starSize = width / 5
        let yGap = starSize * 0.9
        let position = CGPoint(
            x: width / 2,
            y: 5.6 * yGap
        )
        createStarNode(
            starSize: starSize,
            position: position,
            record: record
        )
    }
    
    @MainActor
    private func createStarNode(
        starSize: CGFloat,
        position: CGPoint,
        record: Record
    ) {
        if nodeSet.contains(record.day.yyyyMMdd.description) {
            return
        }
        nodeSet.insert(record.day.yyyyMMdd.description)
        let size = CGSize(width: starSize - 5, height: starSize - 5)
        let starNode = SKSpriteNode(texture: Self.starShapeTexture)
        starNode.size = size
        starNode.position = position
        starNode.physicsBody = SKPhysicsBody(texture: starNode.texture!, size: starNode.size)
        starNode.physicsBody?.affectedByGravity = true
        
        var colors: [Color] = RecordContentType.allCases.compactMap {
            record.records[$0]?.category.color
        }
        if colors.isEmpty {
            colors = [DColor.emptyColor]
        }
        addGradientColor(node: starNode, colors: colors)
        addHighlightTexture(node: starNode, size: size)
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
    
    func addHighlightTexture(node: SKSpriteNode, size: CGSize) {
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
