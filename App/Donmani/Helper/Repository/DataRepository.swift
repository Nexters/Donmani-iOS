//
//  DataRepository.swift
//  Donmani
//
//  Created by 문종식 on 8/6/25.
//

import DNetwork
import ComposableArchitecture

final actor DataRepository {
    private let downloader = DownloadAPI()
    @Dependency(\.fileService) private var fileService
    
    func saveRewardData(from item: Reward) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            if let thumbnailUrl = item.thumbnailUrl {
                group.addTask {
                    let data = try await self.downloader.getResourceData(urlString: thumbnailUrl)
                    try await self.fileService.saveFile(from: data, name: "\(item.name)", type: .thumbnail)
                }
            }
            if let jsonUrl = item.jsonUrl {
                group.addTask {
                    let data = try await self.downloader.getResourceData(urlString: jsonUrl)
                    try await self.fileService.saveFile(from: data, name: "\(item.name)", type: .json)
                }
            }
            if let imageUrl = item.imageUrl {
                group.addTask {
                    let data = try await self.downloader.getResourceData(urlString: imageUrl)
                    try await self.fileService.saveFile(from: data, name: "\(item.name)", type: .image)
                }
            }
            if let soundUrl = item.soundUrl {
                group.addTask {
                    let data = try await self.downloader.getResourceData(urlString: soundUrl)
                    try await self.fileService.saveFile(from: data, name: "\(item.name)", type: .mp3)
                }
            }
            try await group.waitForAll()
        }
    }
    
    func loadRewardData(
        from item: Reward,
        resourceType: Reward.ResourceType
    ) async throws -> Data {
        try await self.fileService.loadFile(
            name: "\(item.name)",
            type: {
                switch resourceType {
                case .thumbnail: .thumbnail
                case .image: .image
                case .json: .json
                case .mp3: .mp3
                }
            }()
        )
    }
}
