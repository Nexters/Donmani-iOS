//
//  ResourceAPI.swift
//  DNetwork
//
//  Created by 문종식 on 8/3/25.
//

public struct DownloadAPI {
    private let request = NetworkRequest()
    
    public init() { }
    
    public func getResourceData(urlString: String) async throws -> Data {
        try await request.get(urlString: urlString)
    }
}
