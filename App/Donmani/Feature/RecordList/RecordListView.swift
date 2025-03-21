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
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: StoreOf<RecordListStore>
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center,spacing: 0) {
                // Navigation Bar
                ZStack {
                    HStack {
                        Spacer()
                        Text("기록")
                            .font(.b1, .semibold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    HStack {
                        DBackButton {
                            dismiss()
                        }
                        Spacer()
                    }
                }
                .frame(height: .navigationBarHeight)
                .padding(.horizontal, .defaultLayoutPadding)
                
                if store.record.isEmpty {
                    ZStack {
                        VStack(spacing: 16) {
                            Spacer()
                            Text("아직 기록이 없어요")
                                .font(DFont.font(.h2, weight: .semibold))
                                .foregroundStyle(DColor(.gray95).color)
                            DButton(title: "기록하기", isEnabled: true) {
                                store.send(.touchRecordButton)
                            }
                            .frame(width: 100)
                            Spacer()
                        }
                    }
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(store.record, id: \.date) { record in
                                VStack {
                                    HStack {
                                        Text(convertDateTitle(record.date) ?? "")
                                            .font(DFont.font(.b2, weight: .medium))
                                            .foregroundStyle(DColor(.gray95).color)
                                        Spacer()
                                    }
                                    if let contents = record.contents {
                                        RecordIntegrateView(
                                            goodRecord: contents[0],
                                            badRecord: contents[1]
                                        )
                                    } else {
                                        EmptyRecordView()
                                    }
                                }
                                .padding(.bottom, 60)
                            }
                            .padding(.horizontal, .defaultLayoutPadding)
                        }
                    }
                    .padding(.top, 17)
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
