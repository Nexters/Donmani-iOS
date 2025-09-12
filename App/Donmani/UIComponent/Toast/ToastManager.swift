//
//  ToastManager.swift
//  Donmani
//
//  Created by 문종식 on 9/12/25.
//

import SwiftUI

final class ToastManager: ObservableObject {
    @Published var type: ToastType = .none
    
    func show(_ type: ToastType) {
        if (self.type == type || type == .none) { return }
        Task { @MainActor in
            withAnimation(.linear(duration: 0.5)) { [weak self] in
                self?.type = type
            } completion: {
                Task(priority: .low) { [weak self] in
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    if self?.type != type { return }
                    await MainActor.run {
                        withAnimation(.linear(duration: 0.5)) { [weak self] in
                            self?.type = .none
                        }
                    }
                }
            }
        }
    }
}
