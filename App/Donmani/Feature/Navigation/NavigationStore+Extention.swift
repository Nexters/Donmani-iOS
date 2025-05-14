//
//  NavigationStore+Extention.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import StoreKit

//extension NavigationStore {
//    func path(
//        state: inout NavigationStore.State,
//        pathElement: StackActionOf<NavigationStore.Path>
//    ) -> Effect<NavigationStore.Action> {
//        switch pathElement {
//        case .element(id: let id, action: let action):
//            switch action {
//            case .main(.delegate(let mainAction)):
//                return mainDelegateAction(state: &state, action: mainAction)
//            case .bottleList(.delegate(let bottleListAction)):
//                return bottleListDelegateAction(id: id, state: &state, action: bottleListAction)
//            case .recordList(.delegate(let recordListAction)):
//                return recordListDelegateAction(id: id, state: &state, action: recordListAction)
//            case .recordWriting(.delegate(let recordWritingAction)):
//                return recordWritingDelegateAction(id: id, state: &state, action: recordWritingAction)
//            case .recordEntryPoint(.delegate(let recordEntryPointAction)):
//                return recordEntryPointDelegateAction(id: id, state: &state, action: recordEntryPointAction)
//            case .monthlyStarBottle(.delegate(let monthlyStarBottleAction)):
//                return monthlyStarBottleDelegateAction(id: id, state: &state, action: monthlyStarBottleAction)
//            case .statistics(_):
//                return .none
//            case .setting:
//                return .none
//            default:
//                return .none
//            }
//        default:
//            return .none
//        }
//    }
//    
//    func addNewRecord(
//        mainState: inout MainStore.State,
//        record: Record?
//    ) {
//        mainState.opacity = 1.0
//        guard let record = record else {
//            return
//        }
//        let stateManager = HistoryStateManager.shared.getState()
//        mainState.recordEntryPointState = RecordEntryPointStore.State(
//            isCompleteToday: stateManager[.today, default: false],
//            isCompleteYesterday: stateManager[.yesterday, default: false]
//        )
//        mainState.isCompleteToday = stateManager[.today, default: false]
//        mainState.isCompleteYesterday = stateManager[.yesterday, default: false]
//        mainState.isPresentingRecordEntryButton = !(stateManager[.today, default: false] && stateManager[.yesterday, default: false])
//        DataStorage.setRecord(record)
//        mainState.monthlyRecords.append(record)
//        mainState.isNewStar += 1
//        Task {
//            let isFirstRecord = HistoryStateManager.shared.getIsFirstRecord()
//            if isFirstRecord == nil {
//                let connectedScenes = await UIApplication.shared.connectedScenes
//                if let windowScene = connectedScenes.map({$0}).first as? UIWindowScene {
//                    await AppStore.requestReview(in: windowScene)
//                    HistoryStateManager.shared.setIsFirstRecord()
//                }
//            }
//        }
//    }
//}
