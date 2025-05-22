//
//  RewardStartStore.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

import UIKit
import ComposableArchitecture
import Lottie

@Reducer
struct RewardStartStore {
    struct Context {
        let recordCount: Int
        let rewardCount: Int
        
        init(recordCount: Int, rewardCount: Int) {
            self.recordCount = recordCount
            self.rewardCount = rewardCount
        }
    }
    
    @ObservableState
    struct State {
        let recordCount: Int
        let rewardCount: Int
        let userName: String
        
        var title: String = "앗! 아직 기록을 작성하지 않았어요"
        var subtitle: String = "오늘부터 기록하고 숨겨진 14개 선물을 받아 보세요!"
        var buttonTitle: String = "기록하러 가기"
        
        var isEnabledButton = true
        var isPresentingGuideText: Bool = false
        var isPresentingGuideBottomSheet: Bool = false
        
        var lastRecordCategory: RecordCategory = .init(GoodCategory.flex)
        
        var feedbackCard: FeedbackCard?
        var dayTitle = "요즘"
        
        var isPresentingFeedbackStartView: Bool = true
        var isPresentingFeedbackTitle: Bool = false
        var isPresentingFeedbackCard: Bool = false
        var isPresentingButton: Bool = true
        
        let lottieAnimation = LottieAnimation.named(
            "RewardStartBottomSheet",
            bundle: .designSystem
        )
        
        init(context: Context) {
            self.recordCount = context.recordCount
            self.rewardCount = context.rewardCount
            self.userName = DataStorage.getUserName()

            
            if context.recordCount > 0 {
                title = "기록하고 토비 선물받기 🎁\n지금까지 \(context.recordCount)번 기록 중"
                subtitle = "14번 기록하면 특별한 선물을 받아요"
                buttonTitle = "지금 선물받기"
                if context.rewardCount == 0 {
                    title = "오늘까지 받을 수 있는 선물을\n모두 받았어요"
                    isEnabledButton = false
                }
            }
            let lastRecordDate = HistoryStateManager.shared.getLastWriteRecordDateKey()
            let todayDate = DateManager.shared.getFormattedDate(for: .today)
            if lastRecordDate == todayDate {
                dayTitle = "오늘"
            }
        }
    }
    
    enum Action {
        case toggleGuideBottomSheet
        case touchGuideBottomSheetButton
        
        case touchNextButton
        
        case requestFeedbackCard
        case receivedFeedbackCard(FeedbackCard?)
        
        case presentFeedbackTitle
        case presentFeedbackCard
        case presentNextButton
        
        case delegate(Delegate)
        enum Delegate {
            case pushRewardReceiveView
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleGuideBottomSheet:
                if HistoryStateManager.shared.getIsFirstRewardEnter() {
                    HistoryStateManager.shared.setIsFirstRewardEnter()
                    state.isPresentingGuideBottomSheet = !state.isPresentingGuideBottomSheet
                    if !state.isPresentingGuideBottomSheet {
                        UINavigationController.isBlockSwipe = false
                    }
                }
                
            case .touchGuideBottomSheetButton:
                if (state.rewardCount > 0) {
                    return .run { send in
                        await send(.toggleGuideBottomSheet)
                        await send(.requestFeedbackCard)
                    }
                } else {
                    return .run { send in
                        await send(.toggleGuideBottomSheet)
                    }
                }
            
            case .touchNextButton:
                if state.feedbackCard == nil {
                    return .run { send in
                        await send(.requestFeedbackCard)
                    }
                } else {
                    UINavigationController.isBlockSwipe = true
                    return .run { send in
                        await send(.delegate(.pushRewardReceiveView))
                    }
                }
                
            case .requestFeedbackCard:
                return .run { send in
                    try await Task.sleep(nanoseconds: .nanosecondsPerSecond / 2)
                    //                    let feedbackCardDTO = try? await NetworkService.DFeedback().receiveFeedbackCard()
                    //                    var feedbackCard: FeedbackCard?
                    //                    if let feedbackCardDTO {
                    //                        feedbackCard = NetworkDTOMapper.mapper(dto: feedbackCardDTO)
                    //                    }
                    let feedbackCard: FeedbackCard? = FeedbackCard.previewData
                    await send(.receivedFeedbackCard(feedbackCard))
                }
            case .receivedFeedbackCard(let feedbackCard):
                state.feedbackCard = feedbackCard
                state.isPresentingFeedbackStartView = false
                state.isPresentingButton = false
                return .run { send in
                    // HStack fade out이 끝난 뒤 애니메이션 시퀀스 시작
                    try await Task.sleep(for: .seconds(0.6))
                    await send(.presentFeedbackTitle)
                    try await Task.sleep(for: .seconds(0.5))
                    await send(.presentFeedbackCard)
                    try await Task.sleep(for: .seconds(0.5))
                    await send(.presentNextButton)
                }
                
            case .presentFeedbackTitle:
                state.isPresentingFeedbackTitle = true
                
            case .presentFeedbackCard:
                state.isPresentingFeedbackCard = true
                state.buttonTitle = "다음"
                
            case .presentNextButton:
                state.isPresentingButton = true
                
            default:
                break
            }
            return .none
        }
    }
}
