//
//  ToastManager.swift
//  Donmani
//
//  Created by 문종식 on 9/12/25.
//

import SwiftUI
import DesignSystem

final class ToastManager: ObservableObject {
    private var type: ToastType = .none
    private var sleepTask: Task<Void, Never>?
    
    @Published var title: String = ""
    @Published var icon: DImageAsset?
    @Published var offset: CGFloat = 0
    @Published var position: ToastPosition?
    
    func show(_ type: ToastType) {
        guard type != .none, self.type != type else { return }
        
        sleepTask?.cancel()
        sleepTask = nil
        
        Task { @MainActor in
            self.type = type
            self.title = type.title
            self.icon = type.icon
            withAnimation(.easeInOut(duration: 0.5)) {
                self.position = type.position
                self.offset = type.offset
            }
        }
        
        sleepTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await Task.sleep(nanoseconds: .nanosecondsPerSecond * 3)
                await MainActor.run {
                    guard self.type == type else { return }
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.position = nil
                        self.offset = 0
                    }
                }
                try await Task.sleep(nanoseconds: 500_000_000)
                await MainActor.run {
                    guard self.type == type else { return }
                    self.type = .none
                    self.title = ""
                    self.icon = nil
                }
            } catch {
                return
            }
        }
    }
}
