//
//  DecorationView.swift
//  Donmani
//
//  Created by 문종식 on 5/19/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

extension DecorationView{
    func EmptyItemListView() -> some View {
        VStack(spacing: 12) {
            DText("아직 아이템이 없어요!")
                .style(.h2, .bold, .deepBlue99)
            DText("기록하면 아이템을 받을 수 있어요")
                .style(.b2, .regular, .deepBlue90)
        }
    }
}
