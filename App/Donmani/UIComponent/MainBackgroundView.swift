//
//  BackgroundView.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

import SwiftUI
import DesignSystem

struct MainBackgroundView: View {
    struct RandomCoordinate: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
    }
    
    let dotSize: CGFloat = 2
    let starSize: CGFloat = 12
    let count: Int
    @State private var dotCoordinates: [RandomCoordinate] = []
    @State private var starCoordinates: [RandomCoordinate] = []
    
    init (starCount: Int) {
        self.count = starCount
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    DColor.backgroundTop,
                    DColor.backgroundBottom
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .padding(-1)
            
            ZStack {
                ForEach(dotCoordinates) { coordinate in
                    backgroundImage(
                        asset: .backgroundDot,
                        size: dotSize,
                        opacity: 0.3,
                        coordinate: coordinate
                    )
                }
                ForEach(starCoordinates) { coordinate in
                    backgroundImage(
                        asset: .backgroundStar,
                        size: starSize,
                        opacity: 0.5,
                        coordinate: coordinate
                    )
                }
            }
            .onAppear {
                fetchUI(in: UIScreen.main.bounds)
            }
        }
    }
    
    private func backgroundImage(
        asset: DImageAsset,
        size: CGFloat,
        opacity: Double,
        coordinate: RandomCoordinate
    ) -> some View {
        DImage(asset).image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size)
            .opacity(opacity)
            .position(x: coordinate.x, y: coordinate.y)
    }
    
    private func fetchUI(in size: CGRect) {
        let edge: CGFloat = 30.0
        starCoordinates = (0..<count).map { _ in
            RandomCoordinate(
                x: CGFloat.random(in: edge...size.width - edge),
                y: CGFloat.random(in: edge...size.height - edge)
            )
        }
        dotCoordinates = (0..<count).map { _ in
            RandomCoordinate(
                x: CGFloat.random(in: edge...size.width - edge),
                y: CGFloat.random(in: edge...size.height - edge)
            )
        }
    }
}

#Preview {
    MainBackgroundView()
}
