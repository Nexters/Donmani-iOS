//
//  FileRepository.swift
//  Donmani
//
//  Created by 문종식 on 8/6/25.
//

import DNetwork
import ComposableArchitecture

protocol FileRepository {
    func saveRewardData(from item: Reward) async throws
    func loadRewardData(from item: Reward, resourceType: Reward.ResourceType) async throws -> Data
}

struct DefaultFileRepository: FileRepository {
    private let downloader = DownloadAPI()
    private var fileDataSource: FileDataSource
    
    init(fileDataSource: FileDataSource) {
        self.fileDataSource = fileDataSource
    }
    
    /// 리워드 리소스 파일 저장
    func saveRewardData(from item: Reward) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            if let thumbnailUrl = item.thumbnailUrl {
                group.addTask {
                    let data = try await self.downloader.getResourceData(urlString: thumbnailUrl)
                    try self.fileDataSource.saveFile(from: data, name: "\(item.name)", type: .thumbnail)
                }
            }
            if let jsonUrl = item.jsonUrl {
                group.addTask {
                    let data = try await self.downloader.getResourceData(urlString: jsonUrl)
                    try self.fileDataSource.saveFile(from: data, name: "\(item.name)", type: .json)
                }
            }
            if let imageUrl = item.imageUrl {
                group.addTask {
                    let data = try await self.downloader.getResourceData(urlString: imageUrl)
                    try self.fileDataSource.saveFile(from: data, name: "\(item.name)", type: .image)
                }
            }
            if let soundUrl = item.soundUrl {
                group.addTask {
                    let data = try await self.downloader.getResourceData(urlString: soundUrl)
                    try self.fileDataSource.saveFile(from: data, name: "\(item.name)", type: .mp3)
                }
            }
            try await group.waitForAll()
        }
    }
    
    /// 리워드 리소스 파일 로드
    func loadRewardData(
        from item: Reward,
        resourceType: Reward.ResourceType
    ) async throws -> Data {
        try fileDataSource.loadFile(
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

extension DependencyValues {
    private enum FileRepositoryKey: DependencyKey {
        static let liveValue: FileRepository = {
            @Dependency(\.fileDataSource) var fileDataSource
            return DefaultFileRepository(
                fileDataSource: fileDataSource
            )
        }()
    }
    
    var fileRepository: FileRepository {
        get { self[FileRepositoryKey.self] }
        set { self[FileRepositoryKey.self] = newValue }
    }
}
