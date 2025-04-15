//
//  MainView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 2/19/25.
//

import SwiftUI
import DesignSystem
import DNetwork

extension MainView {
    func AppStoreView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: {
                UINavigationController.swipeNavigationPopIsEnabled = true
            }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                DText("최신 버전으로 업데이트 부탁드려요!")
                    .style(.h2, .bold, .gray95)
                DText("더 나은 서비스 사용 환경을 위해 최신 버전의 앱으로 업데이트를 부탁드립니다.")
                    .style(.b1, .regular, .gray95)
                
                if let url = URL(string: DURL.appStore.urlString) {
                    Link(destination: url) {
                        ZStack {
                            RoundedRectangle(
                                cornerRadius: 16.0,
                                style: .continuous
                            )
                            .fill(DColor(.gray95).color)
                            .frame(height: 58)
                            DText("업데이트 하기")
                                .style(.h3, .bold, .deepBlue20)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    func NewStarBottleView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: {
                UINavigationController.blockSwipe = false
            }
        ) { dismissSheet in
            VStack(alignment: .center, spacing: .s3) {
                VStack(spacing: 8) {
                    DText("\(store.month)월 별통이가 열렸어요!")
                        .style(.h1, .bold, .gray99)
                    
                    DText("매 월 1일에 새로운 별통이가 열려요")
                        .style(.b1, .regular, .gray95)
                }
                
                ZStack {
                    DImage(.newStarBottleBackground).image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                    
                    DImage(.newStarBottle).image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 167)
                }
                
                Button {
                    dismissSheet {
                        Task {
                            store.send(.dismissNewStarBottleView)
                            let recordDAO = NetworkManager.NMRecord(service: .shared)
                            let result = try await recordDAO.fetchMonthlyRecord(year: 2025).monthlyRecords
                            UINavigationController.blockSwipe = false
                            store.send(.delegate(.pushBottleListView(result)))
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        DText("지난 달 별통이 보러가기")
                            .style(.b1, .regular, .deepBlue90)
                        
                        DImage(.rightArrow).image
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(DColor(.deepBlue90).color)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .s5, height: .s5)
                    }
                }
                
                DButton(title: "확인했어요") {
                    dismissSheet {
                        UINavigationController.blockSwipe = false
                        store.send(.dismissNewStarBottleView)
                    }
                }
            }
        }
    }
    
    func OnboardingEndView() -> some View {
        BottomSheetView(
            isActiveClose: false,
            closeAction: {
                UINavigationController.blockSwipe = false
            }
        ) { dismissSheet in
            VStack(alignment: .leading, spacing: .s3) {
                DText("앗! 어제 오늘 소비 모두 기록 했어요\n내일 또 기록 할 수 있어요!")
                    .style(.h2, .bold, .deepBlue99)
                    .lineSpacing(.s5/2)
                VStack(spacing: 0) {
                    DImage(.onboardingEnd).image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    DButton(title: "확인했어요") {
                        UINavigationController.blockSwipe = false
                        store.send(.dismissAlreadyWrite)
                    }
                }
            }
            .padding(.top, -10)
        }
    }
}
