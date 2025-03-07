//
//  Triangle.swift
//  Donmani
//
//  Created by 문종식 on 3/6/25.
//

import SwiftUI

struct Triangle: Shape {
    enum Direction {
        case up
        case down
    }
    var direction: Direction
    
    init(direction: Direction = .up) {
        self.direction = direction
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        switch self.direction {
        case .down:
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY)) // 꼭짓점 (중앙 아래)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // 오른쪽 위
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // 왼쪽 위
        case .up:
            path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // 꼭짓점 (중앙 위)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // 오른쪽 아래
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // 왼쪽 아래
        }
        path.closeSubpath() // 삼각형 닫기
        return path
    }
}
