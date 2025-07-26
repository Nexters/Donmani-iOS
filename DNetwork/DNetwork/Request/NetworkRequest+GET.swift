//
//  NetworkRequest+GET.swift
//  DNetwork
//
//  Created by 문종식 on 7/26/25.
//

// Get Request
extension DNetworkRequest {
    /// GET Request with Decodable Response
    func get<R: Decodable>(
        path: APIPath,
        addtionalPaths: [String]? = nil,
        parameters: [String: Any]? = nil
    ) async throws -> R {
        let url = try createURL(path, addtionalPaths, parameters)
        let request = createURLReqeust(method: .GET, url: url)
        return try await run(request: request)
    }
    
    /// GET Request with Empty Response
    func get(
        path: APIPath,
        addtionalPaths: [String]? = nil,
        parameters: [String: Any]? = nil
    ) async throws {
        let url = try createURL(path, addtionalPaths, parameters)
        let request = createURLReqeust(method: .GET, url: url)
        try await run(request: request)
    }
    
    
    // Old Request
    public func getData(
        urlString: String
    ) async throws -> Data {
        let url = try createURL(baseURL: urlString)
        return try await getData(url: url)
    }
    
    func getData(
        url: URL
    ) async throws -> Data {
        let request = createURLReqeust(method: .GET, url: url)
        return try await runData(request: request)
    }
    
    public func get<R: Decodable>(
        urlString: String,
        addtionalPath: [String] = [],
        parameters: [String: Any]? = nil
    ) async throws -> R {
        var url = try createURL(baseURL: urlString)
        url.add(paths: addtionalPath)
        if let parameters {
            url = try url.addQueryItems(parameters: parameters)
        }
        return try await get(url: url)
    }
    
    func get<R: Decodable>(
        url: URL
    ) async throws -> R {
        let request = createURLReqeust(method: .GET, url: url)
        return try await run(request: request)
    }
    
    public func get<R: Decodable>(
        path: APIPath,
        addtionalPath: [String] = [],
        parameters: [String: Any]? = nil
    ) async throws -> R {
        var url = try createURL(baseURL: DURL.api.urlString)
        url.add(paths: [path.rawValue])
        url.add(paths: addtionalPath)
        if let parameters {
            url = try url.addQueryItems(parameters: parameters)
        }
        return try await get(url: url)
    }
}
