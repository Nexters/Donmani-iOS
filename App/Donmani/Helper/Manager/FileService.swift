//
//  FileService.swift
//  Donmani
//
//  Created by 문종식 on 6/18/25.
//

import Foundation
import ComposableArchitecture

enum FileType {
    case thumbnail
    case image
    case json
    case mp3
    
    var fileExtension: String {
        switch self {
        case .thumbnail: "png"
        case .image:    "png"
        case .json:     "json"
        case .mp3:      "mp3"
        }
    }
    
    var suffix: String {
        switch self {
        case .thumbnail: "_thumbnail"
        default: ""
        }
    }
}

protocol FileService {
    func saveFile(from data: Data, name: String, type: FileType) async throws
    func loadFile(name: String, type: FileType) async throws -> Data
}

final actor DefaultFileService: FileService {
    private var fileManager: FileManager {
        FileManager.default
    }
    
    private func getFileURL(name: String, type: FileType) -> URL {
        let fileName = "\(name)\(type.suffix).\(type.fileExtension)"
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent(fileName)
    }
    
    func saveFile(from data: Data, name: String, type: FileType) throws {
        let fileURL = getFileURL(name: name, type: type)
        if fileManager.fileExists(atPath: fileURL.path) {
            try? fileManager.removeItem(at: fileURL)
        }
        try data.write(to: fileURL)
    }
    
    func loadFile(name: String, type: FileType) async throws -> Data {
        let fileURL = getFileURL(name: name, type: type)
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw NSError(domain: "DefaultFileService", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        return try Data(contentsOf: fileURL)
    }
}

enum FileServiceDependencyKey: DependencyKey {
    static var liveValue: FileService = DefaultFileService()
}

extension DependencyValues {
    var fileService: FileService {
        get { self[FileServiceDependencyKey.self] }
        set { self[FileServiceDependencyKey.self] = newValue }
    }
}
