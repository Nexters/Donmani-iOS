//
//  SettingStore.swift
//  Donmani
//
//  Created by 문종식 on 6/2/25.
//

import ComposableArchitecture
import DesignSystem
import DNetwork

@Reducer
struct SettingStore {
    
    @ObservableState
    struct State {
        var isPresentingSoundToastView = false
        var isBackgroundSoundOn = false
        var bgmName = ""
        
        init() {
            self.isBackgroundSoundOn = HistoryStateManager.shared.getSouncState()
        }
    }

    
    enum Action: BindableAction {
        case fetchDecorationItem
        case touchDecorationButton
        case toggleBackgroundSound
        case dismissSoundToast
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        enum Delegate {
            case pushDecoration([RewardItemCategory: [Reward]], [Reward])
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .fetchDecorationItem:
                return .run { _ in
                    let dto = try await NetworkService.DReward().reqeustRewardItem()
                    let decorationItem = NetworkDTOMapper.mapper(dto: dto)
                    for reward in (decorationItem[.effect] ?? []) {
                        if let effect = DownloadManager.Effect(rawValue: reward.id),
                           let contentUrl = reward.jsonUrl {
                            let data = try await NetworkService.DReward().downloadData(from: contentUrl)
                            let name = RewardResourceMapper(id: reward.id, category: .effect).resource()
                            try DataStorage.saveJsonFile(data: data, name: name)
                        }
                    }
                    DataStorage.setInventory(decorationItem)
                }
                
            case .touchDecorationButton:
                GA.Click(event: .settingCustomize).send()
                return .run { send in
                    let today = DateManager.shared.getFormattedDate(for: .today).components(separatedBy: "-")
                    let inventoryDTO = try await NetworkService.DReward().reqeustRewardItem()
                    let inventory = NetworkDTOMapper.mapper(dto: inventoryDTO)
                    for reward in (inventory[.effect] ?? []) {
                        if let effect = DownloadManager.Effect(rawValue: reward.id),
                           let contentUrl = reward.jsonUrl {
                            let data = try await NetworkService.DReward().downloadData(from: contentUrl)
                            let name = RewardResourceMapper(id: reward.id, category: .effect).resource()
                            try DataStorage.saveJsonFile(data: data, name: name)
                        }
                    }
                    DataStorage.setInventory(inventory)
                    let year = Int(today[0]) ?? 2025
                    let month = Int(today[1]) ?? 6
                    let decorationItem = DataStorage.getInventory()
                    let dto = try await NetworkService.DReward().reqeustDecorationInfo(year: year, month: month)
                    let currentDecorationItem = NetworkDTOMapper.mapper(dto: dto)
//                    try await NetworkService.User().updateRewardStatus()
                    await send(.delegate(.pushDecoration(decorationItem, currentDecorationItem)))
                }
                
            case .toggleBackgroundSound:
                let decorationItem = DataStorage.getInventory()
                let itemCount = (decorationItem[.sound]?.count ?? 0)
                if (itemCount < 2) {
                    if (state.isPresentingSoundToastView) {
                        break
                    }
                    GA.Click(event: .soundEffectOn).send()
                    state.isPresentingSoundToastView = true
                    return .run { send in
                        try await Task.sleep(nanoseconds: 3_000_000_000)
                        await send(.dismissSoundToast, animation: .linear(duration: 0.5))
                    }
                } else {
                    if (SoundManager.isSoundOn) {
                        GA.Click(event: .soundEffectOff).send()
                        state.isBackgroundSoundOn = false
                        HistoryStateManager.shared.setSouncState(false)
                        SoundManager.shared.stop()
                    } else {
                        GA.Click(event: .soundEffectOn).send()
                        state.isBackgroundSoundOn = true
                        HistoryStateManager.shared.setSouncState(true)
                        let fileName = DataStorage.getSoundFileName()
                        if !fileName.isEmpty {
                            SoundManager.shared.play(fileName: fileName)
                        }
                    }
                    SoundManager.isSoundOn.toggle()
                }
                
            case .dismissSoundToast:
                state.isPresentingSoundToastView = false
                
            default:
                break
            }
            return .none
        }
    }
}
