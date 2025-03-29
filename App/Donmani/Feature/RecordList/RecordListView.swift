//
//  RecordListView.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct RecordListView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var store: StoreOf<RecordListStore>
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center,spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        Spacer()
                        Text("\(store.yearMonth.year)년 \(store.yearMonth.month)월 기록")
                            .font(.b1, .semibold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    HStack {
                        DNavigationBarButton(.leftArrow) {
                            dismiss()
                        }
                        Spacer()
                        if store.isShowNavigationButton {
                            DNavigationBarButton(.bottleIcon) {
                                store.send(.delegate(.pushBottleListView))
                            }
                        }
                    }
                }
                .frame(height: .navigationBarHeight)
                .padding(.horizontal, .defaultLayoutPadding)
                
                if store.record.isEmpty {
                    EmptyGuideView()
                } else {
                    RecordScrollView()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func convertDateTitle(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let koreanFormatter = DateFormatter()
        koreanFormatter.dateFormat = "M월 d일 EEE요일"
        koreanFormatter.locale = Locale(identifier: "ko_KR")
        
        return koreanFormatter.string(from: date)
    }
}

#Preview {
    RecordListView(
        store: Store(
            initialState: RecordListStore.State()
        ) {
            RecordListStore()
        }
    )
}
