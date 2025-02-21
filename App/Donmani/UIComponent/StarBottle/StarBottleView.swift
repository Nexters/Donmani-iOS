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
    
    @State private var starScene = StarScene(
        size: CGSize(
            width: .screenWidth * 0.8,
            height: .screenWidth * 0.8 * 4/3
        )
    )
    
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
            starScene.addGroundNode(
                width: width,
                height: height
            )
            records.forEach {
                starScene.createInitStarNode(
                    width: width,
                    height: height,
                    record: $0
                )
            }
            MotionManager.startGyros { dx, dy in
                starScene.setGravity(dx: dx, dy: -dy)
            }
        }
        .onDisappear {
            MotionManager.stopGyros()
        }
        .onChange(of: records) { (new, old) in
            if let record = records.last {
                starScene.createNewStarNode(
                    width: width,
                    height: height,
                    record: record
                )
            }
        }
        //        .onTapGesture {
        //            starScene.createNewStarNode(
        //            starScene.createInitStarNode(
        //                width: width,
        //                height: height,
        //                record: .init(date: "", contents: [
        //                    .init(flag: .good, category: .init(GoodCategory.allCases.shuffled().first!), memo: ""),
        //                    .init(flag: .bad, category: .init(BadCategory.allCases.shuffled().first!), memo: "")
        //                ])
        //            )
        //        }
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
