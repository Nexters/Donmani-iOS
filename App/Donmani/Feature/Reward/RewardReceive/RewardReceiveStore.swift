//
//  RewardReceiveStore.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import ComposableArchitecture
import Lottie

@Reducer
struct RewardReceiveStore {
    
    struct Context {
        let rewardCount: Int
        init(rewardCount: Int) {
            self.rewardCount = rewardCount
        }
    }
    
    @ObservableState
    struct State {
        var buttonTitle: String = "열어보기"
        var title: String = "응원의 선물을 받았어요!"
        let rewardCount: Int
        
        var isPresentDefaultLottieView = true
        var isPresentMultiRewardGuideText: Bool
        
        var isPresentingMainTitle: Bool = true
        var isPresentingMainImage: Bool = true
        var isPresentingRewardsBox: Bool = true
        var isPresentingRewards: Bool = false
        var isPlayingLottie: Bool = false
        var isPresentingBackButton: Bool  = true
        
        
        var rewardItems: [Reward] = []
        var rewardIndex = 0
        
        var rewardTitle: String {
            let name = rewardItems[rewardIndex].name
            let particle = name.hasFinalConsonant ? "을" : "를"
            return "\(name)\(particle) 받았어요!"
        }
        
        let defaultLottieAnimation = LottieAnimation.named(
            "lottie_reward_present_box",
            bundle: .designSystem
        )
        
        let confettiLottieAnimation = LottieAnimation.named(
            "lottie_confetti",
            bundle: .designSystem
        )
        
        init(context: Context) {
            self.rewardCount = context.rewardCount
            self.isPresentMultiRewardGuideText = (context.rewardCount > 1)
        }
    }
    
    @Dependency(\.recordRepository) var recordRepository
    @Dependency(\.rewardRepository) var rewardRepository
    
    enum Action: BindableAction {
        case touchNextButton
        
        case receiveRewardItems([Reward])
        
        case dismissMainTitle
        case dismissMainImage
        case changeViewContent
        case presentRewardContent
        case presentRewardButton
        case dismissLottie
        
        case binding(BindingAction<State>)
        
        case delegate(Delegate)
        enum Delegate {
            case pushDecorationView([Record], [RewardItemCategory: [Reward]], [Reward], RewardItemCategory)
            case popToRoot
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .touchNextButton:
                if state.rewardItems.isEmpty {
                    return .run { send in
                        GA.Click(event: .rewardReceivedButton).send()
                        let rewards = try await rewardRepository.putOpenReward()
                        await send(.receiveRewardItems(rewards))
                    }
                } else {
                    GA.Click(event: .customizeRewardButton).send()
                    let category: RewardItemCategory = state.rewardItems.last?.category ?? .background
                    return .run { send in
                        let today: Day = .today
                        async let decorationItemTask = rewardRepository.getUserRewardItem()
                        async let currentDecorationItemTask = rewardRepository.getMonthlyRewardItem(year: today.year, month: today.month)
                        async let recordsTask = recordRepository.loadRecords(year: today.year, month: today.month)
                        let (decorationItem, currentDecorationItem, records) = try await (decorationItemTask, currentDecorationItemTask, recordsTask)
                        await send(.delegate(.pushDecorationView(records ?? [], decorationItem, currentDecorationItem, category)))
                    }
                }
                
            case .receiveRewardItems(let rewardItems):
                state.buttonTitle = "받은 선물 꾸며보기"
                state.isPresentingBackButton = false
                state.rewardItems = rewardItems
                state.rewardIndex = 0
                return .run { send in
                    await send(.dismissMainTitle)
                    try await Task.sleep(for: .seconds(0.3))
                    await send(.dismissMainImage)
                    try await Task.sleep(for: .seconds(0.3))
                    await send(.changeViewContent)
                    try await Task.sleep(for: .seconds(0.1))
                    await send(.presentRewardContent)
                    try await Task.sleep(for: .seconds(2.0))
                    await send(.presentRewardButton)
                }
            case .dismissMainTitle:
                state.isPresentingMainTitle = false
                
            case .dismissMainImage:
                state.isPresentingMainImage = false
                
            case .changeViewContent:
                state.isPresentingRewardsBox = false
                state.isPresentingRewards = true
                
            case .presentRewardContent:
                state.isPlayingLottie = true
                
            case .presentRewardButton:
                state.isPresentingBackButton = true
                
            case .dismissLottie:
                state.isPlayingLottie = false
                
            default:
                break
            }
            return .none
        }
    }
}
