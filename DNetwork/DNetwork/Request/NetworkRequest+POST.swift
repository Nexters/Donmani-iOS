//
//  NetworkRequest+POST.swift
//  DNetwork
//
//  Created by 문종식 on 7/26/25.
//

extension DNetworkRequest {
    /// POST Request with Decodable Response
    func post<T: Encodable, R: Decodable>(
        path: APIPath,
        addtionalPaths: [String]? = nil,
        bodyData: T? = nil
    ) async throws -> R {
        let url = try createURL(path, addtionalPaths)
        let request = try createURLReqeust(method: .POST, url: url, bodyData: bodyData)
        return try await run(request: request)
    }
    
    /// POST Request with Empty Response
    func post<T: Encodable> (
        path: APIPath,
        addtionalPaths: [String]? = nil,
        bodyData: T? = nil
    ) async throws {
        let url = try createURL(path, addtionalPaths)
        let request = try createURLReqeust(method: .POST, url: url, bodyData: bodyData)
        try await run(request: request)
    }
    
    
    // Old Request
    public func post<T: Encodable, R: Decodable>(
        urlString: String,
        addtionalPath: [String] = [],
        bodyData: T?
    ) async throws -> R {
        var url = try createURL(baseURL: urlString)
        url.add(paths: addtionalPath)
        return try await post(url: url, bodyData: bodyData)
    }
    
    func post<T: Encodable, R: Decodable>(
        url: URL,
        bodyData: T?
    ) async throws -> R {
        var request = createURLReqeust(method: .POST, url: url)
        if let bodyData {
            guard let body = try? JSONEncoder().encode(bodyData) else {
                throw NetworkError.encodingFailed
            }
            request.httpBody = body
        }
        return try await run(request: request)
    }
    
    public func post<T: Encodable, R: Decodable>(
        path: APIPath,
        addtionalPath: [String] = [],
        bodyData: T?
    ) async throws -> R {
        var url = try createURL(baseURL: DURL.api.urlString)
        url.add(paths: [path.rawValue])
        url.add(paths: addtionalPath)
        return try await post(url: url, bodyData: bodyData)
    }
}
