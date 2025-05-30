//
//  StarBottleView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import SpriteKit
import DesignSystem

struct StarBottleView: View {
    var records: [Record]
    
    var width: CGFloat {
        .screenWidth * 0.8
    }
    
    var height: CGFloat {
        .screenWidth * 0.8 * 4/3
    }
    @State private var starScene: StarScene
    @State var opacity: CGFloat = 0.0
    
    init(
        records: [Record],
        backgroundShape: DImageAsset = .rewardBottleDefaultShape
    ) {
        self.records = records
        self.starScene = StarScene(
            size: CGSize(
                width: .screenWidth * 0.8,
                height: .screenWidth * 0.8 * 4/3
            )
        )
        starScene.addGroundNodeWithStarBottleShape(
            width: width,
            height: height,
            shape: backgroundShape
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
    
    var body: some View {
        SpriteView(
            scene: starScene,
            options: [
                .allowsTransparency,
                .ignoresSiblingOrder
            ]
        )
        .onAppear {
            MotionManager.startGyros { dx, dy in
                starScene.setGravity(dx: dx, dy: -dy)
            }
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
