//
//  MonthlyStarBottleStore.swift
//  Donmani
//
//  Created by 문종식 on 3/27/25.
//

import ComposableArchitecture
import DesignSystem

@Reducer
struct MonthlyStarBottleStore {
    struct Context {
        let year: Int
        let month: Int
        let items: [Reward]
        init(year: Int, month: Int, items: [Reward]) {
            self.year = year
            self.month = month
            self.items = items
        }
    }
    
    // MARK: - State
    @ObservableState
    struct State {
        let record: [Record]
        let year: Int
        let month: Int
        let decorationItem: [RewardItemCategory: Reward]
        
        var backgroundResource : DImageAsset? {
            let id = decorationItem[.background]?.id ?? 1
            switch id {
            case 9:
                return .rewardBgStarOcean
            case 10:
                return .rewardBgPurpleAurora
            case 11:
                return .rewardBgSkyPathway
            default:
                return nil
            }
        }
        
        var byeoltongImageType : DImageAsset {
            let id = decorationItem[.byeoltong]?.id ?? 4
            switch id {
            case 24:
                return .rewardBottleBeads
            case 25:
                return .rewardBottleFuzzy
            default:
                return .rewardBottleDefault
            }
        }
        
        var byeoltongShapeType: DImageAsset {
            let id = decorationItem[.byeoltong]?.id ?? 4
            switch id {
            case 24:
                return .rewardBottleBeadsShape
            case 25:
                return .rewardBottleFuzzyShape
            default:
                return .rewardBottleDefaultShape
            }
        }
        
        init(context: Context) {
            self.year = context.year
            self.month = context.month
            let key = "\(year)-\(String(format: "%02d", month))"
            self.record = (DataStorage.getRecord(yearMonth: key) ?? []).sorted {
                $0.date > $1.date
            }
            var items: [RewardItemCategory: Reward] = [:]
            for item in context.items {
                items[item.category] = item
            }
            self.decorationItem = items
        }
    }
    
    // MARK: - Action
    enum Action {
        case playBackgroundMusic
        case playOriginBackgroundMusic
        
        case delegate(Delegate)
        enum Delegate {
            case pushRecordListView(Int, Int)
        }
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .playBackgroundMusic:
                SoundManager.shared.stop()
                if SoundManager.isSoundOn {
                    let soundId = state.decorationItem[.sound]?.id ?? 5
                    if (soundId > 5) {
                        let fileName = RewardResourceMapper(id: soundId, category: .sound).resource()
                        SoundManager.shared.play(fileName: fileName)
                    }
                }
                return .none
                
            case .playOriginBackgroundMusic:
                SoundManager.shared.stop()
                if SoundManager.isSoundOn {
                    let soundId = DataStorage.getDecorationItem()[.sound]?.id ?? 5
                    if (soundId > 5) {
                        let fileName = RewardResourceMapper(id: soundId, category: .sound).resource()
                        SoundManager.shared.play(fileName: fileName)
                    }
                }
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
