//
//  DecorationStore.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import ComposableArchitecture
import DesignSystem
import Lottie
import SwiftUI

@Reducer
struct DecorationStore {
    struct Context {
        let records: [Record]
        let decorationItem: [RewardItemCategory : [Reward]]
        let currentDecorationItem: [RewardItemCategory : Reward]
        let selectedCategory: RewardItemCategory
        let decorationData: DecorationData
        
        init(
            records: [Record],
            decorationItem: [RewardItemCategory : [Reward]],
            currentDecorationItem: [Reward],
            selectedCategory: RewardItemCategory,
            decorationData: DecorationData
        ) {
            self.records = records
            self.decorationItem = decorationItem
            self.currentDecorationItem = currentDecorationItem.reduce(into: [:]) { result, item in
                result[item.category] = item
            }
            self.selectedCategory = selectedCategory
            self.decorationData = decorationData
        }
    }
    
    @ObservableState
    struct State {
        var isPresentingGuideBottomSheet = false
        var isPresentingFinalBottomSheet = false
        var isPresentingDecorationGuideAlert = false
        var selectedRewardItemCategory: RewardItemCategory = .background
    
        var decorationItem: [RewardItemCategory : [Reward]]
        var selectedDecorationItem: [RewardItemCategory : Reward]
        var previousDecorationItem: [RewardItemCategory : Reward]
        var decorationData: DecorationData
        var backgroundShape: DImageAsset
        
        var disabledSaveButton = true
        var starBottleAction: StarBottleAction = .none
        var toastType: ToastType = .none
        
        var itemList: [Reward] {
            decorationItem[selectedRewardItemCategory, default: []]
        }
        
        var monthlyRecords: [Record]
        
        var isSoundOn: Bool = false
        let lottieAnimation = LottieAnimation.named(
            "lottie_equalizer",
            bundle: .designSystem
        )
        
        let lottieFinalAnimation = LottieAnimation.named(
            "lottie_reward_final_bottom_sheet",
            bundle: .designSystem
        )
        let confettiLottieAnimation = LottieAnimation.named(
            "lottie_confetti",
            bundle: .designSystem
        )
        
        var byeoltongImageType : DImageAsset {
            let id = selectedDecorationItem[.bottle]?.id ?? 4
            switch id {
            case 24:
                return .rewardBottleBeads
            case 25:
                return .rewardBottleFuzzy
            default:
                return .rewardBottleDefault
            }
        }
        
        var byeoltongShapeType : DImageAsset = .rewardBottleDefaultShape
        
        init(context: Context) {
            self.decorationItem = context.decorationItem
            self.selectedDecorationItem = context.currentDecorationItem
            self.previousDecorationItem = context.currentDecorationItem
            self.selectedRewardItemCategory = context.selectedCategory
            self.monthlyRecords = context.records
            self.decorationData = context.decorationData
            backgroundShape = .rewardBottleDefault
            byeoltongShapeType = {
                switch (context.currentDecorationItem[.bottle]?.id ?? 4) {
                case 24:
                    return .rewardBottleBeadsShape
                case 25:
                    return .rewardBottleFuzzyShape
                default:
                    return .rewardBottleDefaultShape
                }
            }()
            self.isPresentingGuideBottomSheet = HistoryStateManager.shared.getIsFirstDecorationEnter()
            self.decorationItem.forEach {
                if ($0.key == .decoration) {
                    for item in $0.value {
                        if (item.hidden && !item.hiddenRead) {
                            self.isPresentingFinalBottomSheet = true
                        }
                    }
                }
            }
        }
    }
    
    @Dependency(\.rewardRepository) var rewardRepository
    @Dependency(\.fileRepository) var fileRepository
    @Dependency(\.settings) var settings
    
    enum Action: BindableAction {
        case toggleGuideBottomSheet
        case touchGuideBottomSheetButton
        case touchFinalBottomSheetButton
        
        case touchRewardItemCategoryButton(RewardItemCategory)
        case touchRewardItem(RewardItemCategory, Reward)

        case touchBackButton
        case touchSaveButton
        case cancelSave
        case saveDecorationItem
        case showSaveSuccessToast
        
        case changeItem(RewardItemCategory, Reward)
        case changeBackgroundItem(Data)
        case changeEffectItem(Data)
        case changeDecorationItem(Int, String)
        case changeBottleShapeItem(Int, BottleShape)
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        enum Delegate {
            case pop(Bool)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .toggleGuideBottomSheet:
                GA.View(event: .customize).send()
                if HistoryStateManager.shared.getIsFirstDecorationEnter() {
                    HistoryStateManager.shared.setIsFirstDecorationEnter()
                    state.isPresentingGuideBottomSheet = !state.isPresentingGuideBottomSheet
                    if !state.isPresentingGuideBottomSheet {
                        UINavigationController.isBlockSwipe = false
                    }
                }
                
            case .touchGuideBottomSheetButton:
                return .run { send in
                    await send(.toggleGuideBottomSheet)
                }
                
            case .touchFinalBottomSheetButton:
                state.isPresentingFinalBottomSheet = false
                HistoryStateManager.shared.setIsShownFullRewardBottmeSheet()
                UINavigationController.isBlockSwipe = false
                return .run { send in
                    let day: Day = .today
                    try await rewardRepository.putHiddenRead(year: day.year, month: day.month)
                }
                
            case .touchRewardItemCategoryButton(let category):
                state.selectedRewardItemCategory = category
                
            case .touchRewardItem(let category, let item):
                guard let previousItem = state.selectedDecorationItem[category] else {
                    return .none
                }
                if (previousItem.id == item.id) {
                    return .none
                }
                state.selectedDecorationItem[category] = item
                let diffCount = state.previousDecorationItem.compactMap { (key, item) in
                    (state.selectedDecorationItem[key]?.id ?? 0) == (item.id) ? nil : 0
                }.count
                state.disabledSaveButton = (diffCount == 0)
                if (item.id == 23 && !item.hiddenRead) {
                    Task {
                        let day: Day = .today
                        try await rewardRepository.putHiddenRead(year: day.year, month: day.month)
                    }
                }
                return .run { send in
                    await send(.changeItem(category, item))
                }
                
            case .touchBackButton:
                return .run { send in
                    await send(.delegate(.pop(false)))
                }
            
            case .touchSaveButton:
                let isFirstSave = HistoryStateManager.shared.getIsFirstDecorationSave()
                if isFirstSave {
                    state.isPresentingDecorationGuideAlert = true
                } else {
                    return .run { send in
                        await send(.saveDecorationItem)
                    }
                }

            case .cancelSave:
                state.isPresentingDecorationGuideAlert = false
                
            case .saveDecorationItem:
                HistoryStateManager.shared.setIsFirstDecorationSave()
                GA.Click(event: .customizeSubmitButton).send(parameters: [
                    .reward_배경: state.selectedDecorationItem[.background]?.name ?? "",
                    .reward_효과: state.selectedDecorationItem[.effect]?.name ?? "",
                    .reward_장식: state.selectedDecorationItem[.decoration]?.name ?? "",
                    .reward_별통이: state.selectedDecorationItem[.bottle]?.name ?? "",
                    .reward_효과음: state.selectedDecorationItem[.sound]?.name ?? "",
                ])
                let item = state.selectedDecorationItem
                let day: Day = .today
                rewardRepository.saveEquippedItems(
                    year: day.year,
                    month: day.month,
                    items: item.map { (_, value) in value }
                )
                return .run { send in
                    try await rewardRepository.putSaveReward(
                        year: day.year,
                        month: day.month,
                        backgroundId: item[.background]?.id ?? 0,
                        effectId: item[.effect]?.id ?? 0,
                        decorationId: item[.decoration]?.id ?? 0,
                        byeoltongCaseId: item[.bottle]?.id ?? 0
                    )
                    await send(.showSaveSuccessToast)
                }
            
            case .showSaveSuccessToast:
                state.toastType = .successSaveDecoration
                return .run { send in
                    await send(.delegate(.pop(true)))
                }
                
            case .changeItem(let category, let item):
                return .run { send in
                    switch category {
                    case .background:
                        let data = try fileRepository.loadRewardData(from: item, resourceType: .image)
                        await send(.changeBackgroundItem(data))
                    case .effect:
                        let data = try fileRepository.loadRewardData(from: item, resourceType: .json)
                        await send(.changeEffectItem(data))
                    case .decoration:
                        let name = RewardResourceMapper(
                            id: item.id,
                            category: .decoration
                        ).resource()
                        await send(.changeDecorationItem(item.id, name))
                    case .bottle:
                        await send(.changeBottleShapeItem(item.id, BottleShape(id: item.id)))
                    case .sound:
                        break
                    }
                }
                
            case .changeBackgroundItem(let data):
                state.starBottleAction = .changeBackgroundItem(data)
            case .changeEffectItem(let data):
                state.starBottleAction = .changeEffectItem(data)
            case .changeDecorationItem(let id, let name):
                state.starBottleAction = .changeDecorationItem(id, name)
            case .changeBottleShapeItem(let id, let bottleShape):
                state.starBottleAction = .changeBottleItem(id, bottleShape)
            default:
                break
            }

            return .none
        }
    }
}
