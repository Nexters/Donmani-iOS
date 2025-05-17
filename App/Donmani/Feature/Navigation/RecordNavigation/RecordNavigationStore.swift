//
//  RecordNavigationStore.swift
//  Donmani
//
//  Created by 문종식 on 5/13/25.
//

import ComposableArchitecture

@Reducer
struct RecordNavigationStore {
    
    @ObservableState
    struct State {
        var recordState: RecordEntryPointStore.State
        var path = StackState<RecordNavigationStore.Path.State>()
        
        init(recordState: RecordEntryPointStore.State) {
            self.recordState = recordState
        }
    }
    
    enum Action {
        case recordAction(RecordEntryPointStore.Action)
        case path(StackActionOf<RecordNavigationStore.Path>)
        
        case pushRecordWrite
    }
    
    var body: some ReducerOf<Self> {
        Scope(
            state: \.recordState,
            action: \.recordAction
        ) {
            RecordEntryPointStore()
        }
        
        Reduce { state, action in
            switch action {
            case .recordAction(let recordAction):
//                switch recordAction {
//                case .delegate(let action):
//                    
//                default: break
//                }
                break;
            case .path(let element):
                break
            case .pushRecordWrite:
                break
            }
            
            return .none
        }
        .forEach(\.path, action: \.path)
    }
}

extension RecordNavigationStore {
    @Reducer
    enum Path {
        case recordWrite(RecordWritingStore)
    }
}
