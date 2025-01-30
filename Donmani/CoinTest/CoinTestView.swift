//
//  CoinTestView.swift
//  Donmani
//
//  Created by 문종식 on 1/30/25.
//

import SwiftUI
import SpriteKit

struct CoinTestView: View {
    let coinScene = CoinScene()
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    .frame(width: 0, height: 200, alignment: .center)
                SpriteView(
                    scene: coinScene,
                    options: [
                        .allowsTransparency,
                        .ignoresSiblingOrder
                    ]
                )
//                .background(Color.gray)
                .background(Color.clear)
                .aspectRatio(contentMode: .fill)
                .onAppear {
                    coinScene.replaceObject(w: geometry.size.width)
                }
                .onTapGesture {
                    coinScene.shotCoin(w: geometry.size.width)
                }
            }
        }
        
    }
}

#Preview {
    CoinTestView()
}
