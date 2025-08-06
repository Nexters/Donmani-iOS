//
//  OnboardingStore.swift
//  Donmani
//
//  Created by 문종식 on 3/18/25.
//

import ComposableArchitecture
import DesignSystem

@Reducer
struct OnboardingStore {
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        enum Step {
            case cover
            case page
            case final
        }
        
        var step: Step = .cover
        var pageIndex = 0
        var isPresentingEndOnboardingView = false
        var startViewtype: RootStore.MainRoute = .main
        
        let guidePageCount = 5
        
        let guideTitles: [String] = [
            "행복 소비 후회 소비를\n한 개씩 기록할 수 있어",
            "소비의 의미를\n스스로 돌아보는 게 중요해",
            "기록을 저장하면\n수정할 수 없어",
            "어제와 오늘 소비만\n기록할 수 있어",
            "쉽게 예시를 보여줄게\n이렇게 기록해 보는 거야!",
        ]
        
        let guideContents: [String] = [
            "하루에 한 개씩만 적으니까\n소비가 남긴 감정에 더 집중할 수 있어",
            "고민하다 보면 자연스럽게\n더 나은 선택을 하게 될 거야",
            "소비 당시 있는 그대로의\n감정이 중요하기 때문이야",
            "지난 과거는 기억이 바뀌잖아\n별별소는 하루의 솔직한 감정을\n중요하게 생각해",
            "그럼 이제 시작해 볼까?",
        ]
        
        let guideImageAssets: [DImageAsset] = [
            .onboardingPage0,
            .onboardingPage1,
            .onboardingPage2,
            .onboardingPage3,
            .onboardingPage4,
        ]
        
        let guideBottomPadding: [CGFloat] = [51,8,0,0,0]
        
        init() {
            
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction, Equatable {
        case touchStartOnboarding
        case touchNextPage
        case touchEndOnboarding
        
        case touchFinalButton(RootStore.MainRoute)
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        enum Delegate: Equatable {
            case pushMainView(Bool)
            case pushRecordEntryPointView
        }
    }
    
    // MARK: - Dependency
    
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .touchStartOnboarding:
                state.step = .page
                
            case .touchNextPage:
                state.pageIndex += 1
                state.step = state.pageIndex < 4 ? .page : .final
                
            case .touchFinalButton(let type):
                state.startViewtype = type
                state.isPresentingEndOnboardingView = true
                
            case .touchEndOnboarding:
                Settings.shouldShowOnboarding = false
                
            case .binding(\.pageIndex):
                state.step = state.pageIndex < 4 ? .page : .final
                
            default:
                break
            }
            return .none
        }
    }
}
