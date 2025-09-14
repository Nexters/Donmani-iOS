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
    
    case changeBackgroundItem(Data)
    case changeEffectItem(Data)
    case changeDecorationItem(Int, String)
    case changeBottleItem(Int, BottleShape)
    
    case none
}

enum StarBottleViewType {
    case `default`
    case decoration
}

struct DecorationData {
    let backgroundRewardData: Data?
    let effectRewardData: Data?
    let decorationRewardName: String?
    let decorationRewardId: Int?
    let bottleRewardId: Int?
    let bottleShape: BottleShape
    
    init(backgroundRewardData: Data?, effectRewardData: Data?, decorationRewardName: String?, decorationRewardId: Int?, bottleRewardId: Int?, bottleShape: BottleShape) {
        self.backgroundRewardData = backgroundRewardData
        self.effectRewardData = effectRewardData
        self.decorationRewardName = decorationRewardName
        self.decorationRewardId = decorationRewardId
        self.bottleRewardId = bottleRewardId
        self.bottleShape = bottleShape
    }
}

struct StarBottleView: View {
    static var width: CGFloat {
        .screenWidth - (38 * 2)
    }
    
    static var height: CGFloat {
        width * 1.25
    }
    
    var width: CGFloat {
        .screenWidth - (38 * 2) - (self.viewType == .decoration ? 90 : 0)
    }
    
    var height: CGFloat {
        width * 1.25
    }
    
    let motionManager = MotionManager()
    let viewType: StarBottleViewType
    
    var spaceVacanceItemOffset: CGPoint {
        let offsetY: CGFloat = switch bottleShape {
        case .bead:
            -.screenWidth * 0.21 * 0.4
        case .heart:
            viewType == .decoration ? -.screenWidth * 0.21 * 0.3 : -.screenWidth * 0.21 * 0.1
        case .default:
            -.screenWidth * 0.21 * 0.8
        }
        let offsetX: CGFloat = switch bottleShape {
        case .bead:
            0
        case .heart:
            viewType == .decoration ? .screenWidth * 0.21 * 0.7 : .screenWidth * 0.21
        case .default:
            viewType == .decoration ? .screenWidth * 0.21 * 0.6 : .screenWidth * 0.21 * 0.8
        }
        return CGPoint(
            x: offsetX,
            y: offsetY
        )
    }
    
    private let onTapGesture: (() -> Void)?
    
    @Binding private var starBottleAction: StarBottleAction
    
    @State private var starBottleScene: StarBottleScene
    @State var opacity: CGFloat = 0.0
    @State private var records: [Record]
    
    @Dependency(\.rewardDataUseCase) var rewardDataUseCase
    
    @State var backgroundRewardData: Data?
    @State var effectRewardData: Data?
    @State var decorationRewardName: String?
    @State var decorationRewardId: Int?
    @State var bottleRewardId: Int?
    @State var bottleShape: BottleShape
    
    func fetchUI() {
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
        decorationData: DecorationData,
        viewType: StarBottleViewType = .default,
        starBottleAction: Binding<StarBottleAction> = .constant(.none),
        onTapGesture: (() -> Void)? = nil
    ) {
        self.records = records
        self.viewType = viewType
        self._starBottleAction = starBottleAction
        self.starBottleScene = StarBottleScene(
            size: .init(
                width: Self.width,
                height: Self.height
            ),
            bottleShape: decorationData.bottleShape
        )
        self.backgroundRewardData = decorationData.backgroundRewardData
        self.effectRewardData = decorationData.effectRewardData
        self.decorationRewardName = decorationData.decorationRewardName
        self.decorationRewardId = decorationData.decorationRewardId
        self.bottleRewardId = decorationData.bottleRewardId
        self.bottleShape = decorationData.bottleShape
        
        self.onTapGesture = onTapGesture
    }
    
    var body: some View {
        ZStack {
            if let backgroundRewardData,
               let image = UIImage(data: backgroundRewardData) {
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
            
            if let effectRewardData {
                GeometryReader { proxy in
                    DLottieView(
                        data: effectRewardData,
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
                        .frame(width: width + 20)
                        .aspectRatio(0.8, contentMode: .fit)
                    
                    SpriteView(
                        scene: starBottleScene,
                        options: [
                            .allowsTransparency,
                            .ignoresSiblingOrder,
                        ]
                    )
                    .frame(width: width, height: height)
                    
                    if let bottleRewardId {
                        RewardResourceMapper(
                            id: bottleRewardId,
                            category: .bottle
                        )
                        .image()
                        .image
                        .resizable()
                        .frame(width: width)
                        .aspectRatio(0.8, contentMode: .fit)
                        .onTapGesture {
                            onTapGesture?()
                        }
                        .overlay {
                            if let decorationRewardName, let decorationRewardId {
                                if decorationRewardId == 20 { // 둥둥배
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            DLottieView(
                                                name: decorationRewardName,
                                                loopMode: .loop
                                            )
                                            .frame(width: 80, height: 80)
                                        }
                                    }
                                    .allowsHitTesting(false)
                                    .offset(
                                        x: viewType == .decoration ? (Self.width/6) : 0,
                                        y: viewType == .decoration ? (Self.width/8) : (Self.width/5)
                                    )
                                } else if decorationRewardId == 23 { // 우주바캉스 토비
                                    VStack {
                                        HStack {
                                            DImage(.rewardDecorationSpaceVacance)
                                                .image
                                                .resizable()
                                                .aspectRatio(0.67, contentMode: .fit)
                                                .frame(height: .screenWidth * 0.27)
                                                .offset(
                                                    x: spaceVacanceItemOffset.x,
                                                    y: spaceVacanceItemOffset.y
                                                )
                                        }
                                        Spacer()
                                    }
                                } else { // 토비호, 몽글몽글 열기구, 달베개
                                    VStack {
                                        HStack {
                                            DLottieView(
                                                name: decorationRewardName,
                                                loopMode: .loop
                                            )
                                            .frame(width: 80, height: 80)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .allowsHitTesting(false)
                                    .offset(
                                        x: viewType == .decoration ? -(Self.width/5) : -(Self.width/10),
                                        y: viewType == .decoration ? -(Self.width/10) : -(Self.width/5)
                                    )
                                }
                            }
                        }
                    } else {
                        DImage(.lockedStarBottle).image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 38)
                    }
                    
                }
                .padding(.bottom, viewType == .decoration ? 70 : (70 + 52 + .s5))
                
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
            case .changeBackgroundItem(let data):
                backgroundRewardData = data
            case .changeEffectItem(let data):
                effectRewardData = data
            case .changeDecorationItem(let id, let name):
                decorationRewardId = id
                decorationRewardName = name
            case .changeBottleItem(let id, let bottleShape):
                bottleRewardId = id
                self.bottleShape = bottleShape
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
