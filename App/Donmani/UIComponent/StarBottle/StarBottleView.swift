//
//  StarBottleView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import SpriteKit

struct StarBottleView: View {
    var records: [Record]
    
    var width: CGFloat {
        .screenWidth * 0.8
    }
    
    var height: CGFloat {
        .screenWidth * 0.8 * 4/3
    }
    @State private var starScene: StarScene
    
    init(records: [Record]) {
        self.records = records
        self.starScene = StarScene(
            size: CGSize(
                width: .screenWidth * 0.8,
                height: .screenWidth * 0.8 * 4/3
            )
        )
    }
    
    var body: some View {
        SpriteView(
            scene: starScene,
            options: [
                .allowsTransparency,
                .ignoresSiblingOrder
            ]
        )
        .background(Color.clear)
        .onAppear {
            MotionManager.startGyros { dx, dy in
                starScene.setGravity(dx: dx, dy: -dy)
            }
            starScene.addGroundNodeWithStarBottleShape(
                width: width,
                height: height
            )
            (0..<records.count).forEach { i in
                starScene.createInitStarNode(
                    width: width,
                    height: height,
                    record: records[i],
                    index: i
                )
            }
            starScene.backgroundColor = .clear.withAlphaComponent(0.0)
            starScene.scene?.backgroundColor = .clear.withAlphaComponent(0.0)
            starScene.scene?.view?.backgroundColor = .clear.withAlphaComponent(0.0)
            starScene.view?.backgroundColor = .clear.withAlphaComponent(0.0)
        }
        .onChange(of: records) { (old, new) in
            if let record = records.last {
                starScene.createNewStarNode(
                    width: width,
                    height: height,
                    record: record
                )
            }
        }
        .onDisappear {
            MotionManager.stopGyros()
        }
    }
}

#Preview {
    StarBottleView(
        records: (0..<31).map {
            .init(
                date: "\($0)",
                contents: [
                    .init(flag: .good, category: .init(GoodCategory.allCases.shuffled().first!), memo: ""),
                    .init(flag: .bad, category: .init(BadCategory.allCases.shuffled().first!), memo: "")
                ]
            )
        }
    )
}
