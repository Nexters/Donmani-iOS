//
//  NetworkRequest+GET.swift
//  DNetwork
//
//  Created by 문종식 on 7/26/25.
//

// Get Request
extension NetworkRequest {
    /// GET Request with Decodable Response
    func get<R: Decodable>(
        path: APIPath?,
        additionalPaths: [String]? = nil,
        parameters: [String: Any]? = nil
    ) async throws -> R {
        let url = try createURL(path, additionalPaths, parameters)
        let request = createURLRequest(method: .GET, url: url)
        return try await run(request: request)
    }
    
    /// GET Request with Empty Response
    func get(
        path: APIPath?,
        additionalPaths: [String]? = nil,
        parameters: [String: Any]? = nil
    ) async throws {
        let url = try createURL(path, additionalPaths, parameters)
        let request = createURLRequest(method: .GET, url: url)
        try await run(request: request)
    }
    
    /// GET Request with Raw URL String
    func get(
        urlString: String,
        additionalPaths: [String]? = nil,
        parameters: [String: Any]? = nil
    ) async throws -> Data {
        let url = try createURL(urlString, additionalPaths, parameters)
        let request = createURLRequest(method: .GET, url: url)
        return try await run(dataRequest: request)
    }
}
