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
            SpriteView(
                scene: coinScene,
                options: [
                    .allowsTransparency,
                    .ignoresSiblingOrder
                ]
            )
            .background(Color.black.opacity(0.6))
            .aspectRatio(contentMode: .fill)
            .onAppear {
                coinScene.replaceObject(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                MotionManager.startGyros { dx, dy in
                    coinScene.setGravity(dx: dx, dy: -dy)
                }
            }
            .onTapGesture {
                coinScene.shotCoin(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
            }
        }
        .frame(width: 335, height: 400)
        .onDisappear {
            MotionManager.stopGyros()
        }
        
    }
}

#Preview {
    CoinTestView()
}
