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
        
        var isEnabledButton = true
        var isPresentDefaultLottieView = true
        var isPresentMultiRewardGuideText: Bool
        
        var isPresentingMainTitle: Bool = true
        var isPresentingMainImage: Bool = true
        var isPresentingRewards = false
        var isPresentingRewardTitle: Bool = false
        var isPlayingLottie: Bool = false
        var isPresentingBackButton = true
        
        
        var rewardItems: [RewardItem] = []
        var rewardIndex = 0
        
        var rewardTitle: String {
            "\(rewardItems[rewardIndex].name)를/을 받았어요!"
        }
        
        let defaultLottieAnimation = LottieAnimation.named(
            "RewardPresentBox",
            bundle: .designSystem
        )
        
        let confettiLottieAnimation = LottieAnimation.named(
            "Confetti",
            bundle: .designSystem
        )
        
        init(context: Context) {
            self.rewardCount = context.rewardCount
            self.isPresentMultiRewardGuideText = (context.rewardCount > 1)
        }
    }
    
    enum Action: BindableAction {
        case touchNextButton
        
        case receiveRewardItems([RewardItem])
        
        case dismissMainTitle
        case dismissMainImage
        case presentRewardImageAndLottie
        case presentRewardTitle
        case dismissLottie
        
        
        case binding(BindingAction<State>)
        
        case delegate(Delegate)
        enum Delegate {
            case pushDecorationView
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .touchNextButton:
//                let count = state.rewardCount
                if state.rewardItems.isEmpty {
                    state.isEnabledButton = false
                    return .run { send in
                        //                        let rewardDTO = try await NetworkService.DReward().reqeustAcquireRewards(count: count)
                        //                        let rewardItems: [RewardItem] = NetworkDTOMapper.mapper(dto: rewardDTO)
                        let rewardItems = RewardItem.previewData
                        await send(.receiveRewardItems(rewardItems))
                    }
                } else {
                    return .run { send in
                        await send(.delegate(.pushDecorationView))
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
                    try await Task.sleep(for: .seconds(0.3 + 0.2)) // 0.3초 후 0.2초 대기
                    await send(.presentRewardImageAndLottie)
                    try await Task.sleep(for: .seconds(0.3))
                    await send(.presentRewardTitle)
                }
            case .dismissMainTitle:
                state.isPresentingMainTitle = false
                
            case .dismissMainImage:
                state.isPresentingMainImage = false
                
            case .presentRewardImageAndLottie:
                state.isPresentingRewards = true
                state.isPlayingLottie = true
                
            case .presentRewardTitle:
                state.isPresentingRewardTitle = true
                state.isEnabledButton = true
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
