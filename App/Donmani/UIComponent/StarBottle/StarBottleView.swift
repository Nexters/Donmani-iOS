//
//  StarBottleView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import SpriteKit
import DesignSystem
import ComposableArchitecture

enum StarBottleAction: Equatable {
    case addNewStar(Record)
    case none
}

struct StarBottleView: View {
    static var width: CGFloat {
        .screenWidth - (38 * 2)
    }
    
    static var height: CGFloat {
        width * 1.25
    }
    
    let motionManager = MotionManager()
    private let onTapGesture: (() -> Void)?
    
    @Binding private var starBottleAction: StarBottleAction
    
    @State private var starBottleScene: StarBottleScene
    @State var opacity: CGFloat = 0.0
    @State private var records: [Record]
    @State private var decorationItems: [RewardItemCategory: Reward]
    
    @Dependency(\.rewardDataUseCase) var rewardDataUseCase
    
    @State var backgroundData: Data?
    @State var effectData: Data?
    @State var decorationData: Data?
    @State var bottleRewardId: Int?
    @State var bottleShape: BottleShape
    
    func fetchUI() {
        backgroundData = {
            guard let backgroundReward = decorationItems[.background] else {
                return nil
            }
            return rewardDataUseCase.loadData(from: backgroundReward)
        }()
        
        effectData = {
            guard let effectReward = decorationItems[.effect] else {
                return Data()
            }
            return rewardDataUseCase.loadData(from: effectReward)
        }()
        
        decorationData = {
            guard let decorationReward = decorationItems[.decoration] else {
                return Data()
            }
            return rewardDataUseCase.loadData(from: decorationReward)
        }()
        
        bottleRewardId = decorationItems[.bottle]?.id
        bottleShape = BottleShape(id: decorationItems[.bottle]?.id ?? .zero)
        
        for i in 0..<records.count {
            starBottleScene.createInitStarNode(
                width: Self.width,
                height: Self.height,
                record: records[i],
                index: i
            )
        }
    }
    
    init(
        records: [Record],
        decorationItems: [RewardItemCategory: Reward],
        starBottleAction: Binding<StarBottleAction> = .constant(.none),
        onTapGesture: (() -> Void)? = nil
    ) {
        self.records = records
        self.decorationItems = decorationItems
        self._starBottleAction = starBottleAction
        self.bottleShape = BottleShape(id: decorationItems[.bottle]?.id ?? .zero)
        self.starBottleScene = StarBottleScene(
            size: .init(
                width: Self.width,
                height: Self.height
            ),
            bottleShape: BottleShape(id: decorationItems[.bottle]?.id ?? .zero)
        )
        self.onTapGesture = onTapGesture
    }
    
    var body: some View {
        ZStack {
            if let backgroundData,
               let image = UIImage(data: backgroundData) {
                Image(uiImage: image)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .padding(-5)
            } else {
                BackgroundView(colors: [
                    DColor.backgroundTop,
                    DColor.backgroundBottom,
                ])
            }
            DImage(.mainBackgroundStar).image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .screenWidth - 2 * .defaultLayoutPadding)
            
            if let effectData {
                GeometryReader { proxy in
                    DLottieView(
                        data: effectData,
                        loopMode: .loop
                    )
                    .frame(
                        width: proxy.size.width,
                        height: .screenHeight
                    )
                    .ignoresSafeArea()
                }
                .allowsHitTesting(false)
            }
            VStack {
                Spacer()
                ZStack {
                    DImage(.byeoltongBackground).image
                        .resizable()
                        .frame(width: Self.width + 20)
                        .aspectRatio(0.8, contentMode: .fit)
                    
                    SpriteView(
                        scene: starBottleScene,
                        options: [
                            .allowsTransparency,
                            .ignoresSiblingOrder,
                        ]
                    )
                    .frame(width: Self.width, height: Self.height)
                    
                    if let bottleRewardId {
                        RewardResourceMapper(
                            id: bottleRewardId,
                            category: .bottle
                        )
                        .image()
                        .image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Self.width)
                        .aspectRatio(0.8, contentMode: .fit)
                        .onTapGesture {
                            onTapGesture?()
                        }
                    } else {
                        DImage(.lockedStarBottle).image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 38)
                    }
                }
                .padding(.bottom, 70 + 52 + .s5)
            }
            
            
        }
        .onAppear {
            fetchUI()
            motionManager.startGyros { dx, dy in
                starBottleScene.setGravity(dx: dx, dy: -dy)
            }
        }
        .onDisappear {
            //            motionManager.stopGyros()
        }
        .onChange(of: starBottleAction) { (_, action) in
            switch action {
            case .addNewStar(let record):
                starBottleScene.createNewStarNode(
                    width: Self.width,
                    height: Self.height,
                    record: record
                )
            case .none:
                break
            }
        }
        .onChange(of: bottleShape) { _, newValue in
            starBottleScene.nodeSet.removeAll()
            starBottleScene.removeAllChildren()
            starBottleScene.bottleShape = newValue
            starBottleScene.addGroundNodeWithStarBottleShape(
                width: Self.width,
                height: Self.height,
                shape: newValue
            )
            (0..<records.count).forEach { i in
                starBottleScene.createInitStarNode(
                    width: Self.width,
                    height: Self.height,
                    record: records[i],
                    index: i
                )
            }
        }
    }
}
