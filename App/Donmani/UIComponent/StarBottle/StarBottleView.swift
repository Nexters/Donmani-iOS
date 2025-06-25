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
    
    let width: CGFloat
    let height: CGFloat
    let motionManager = MotionManager()
    @State private var starScene: StarScene
    @State var opacity: CGFloat = 0.0
    @Binding var backgroundBottleShape: DImageAsset

    init(
        size: CGFloat,
        records: [Record],
        backgroundShape: Binding<DImageAsset>
    ) {
        self.width = size
        self.height = size * 5/4
        self.records = records
        self.starScene = StarScene(
            size: CGSize(
                width: size,
                height: size * 5/4
            ),
            currentByeoltongType: backgroundShape.wrappedValue
        )
        self._backgroundBottleShape = backgroundShape
        starScene.addGroundNodeWithStarBottleShape(
            width: width,
            height: height,
            shape: backgroundShape.wrappedValue
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
                .ignoresSiblingOrder,
            ]
        )
        .onAppear {
            motionManager.startGyros { dx, dy in
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
//            motionManager.stopGyros()
        }
        .onChange(of: backgroundBottleShape) { _, newValue in
            starScene.nodeSet.removeAll()
            starScene.removeAllChildren()
            starScene.currentByeoltongType = newValue
            starScene.addGroundNodeWithStarBottleShape(
                width: width,
                height: height,
                shape: newValue
            )
            (0..<records.count).forEach { i in
                starScene.createInitStarNode(
                    width: width,
                    height: height,
                    record: records[i],
                    index: i
                )
            }
        }
    }
}
