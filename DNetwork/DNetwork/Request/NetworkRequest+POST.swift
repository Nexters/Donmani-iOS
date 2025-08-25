//
//  NetworkRequest+POST.swift
//  DNetwork
//
//  Created by 문종식 on 7/26/25.
//

extension NetworkRequest {
    /// POST Request with Decodable Response
    func post<T: Encodable, R: Decodable>(
        path: APIPath?,
        additionalPaths: [String]? = nil,
        bodyData: T? = nil
    ) async throws -> R {
        let url = try createURL(path, additionalPaths)
        let request = try createURLRequest(method: .POST, url: url, bodyData: bodyData)
        return try await run(request: request)
    }
    
    /// POST Request with Empty Response
    func post<T: Encodable> (
        path: APIPath?,
        additionalPaths: [String]? = nil,
        bodyData: T? = nil
    ) async throws {
        let url = try createURL(path, additionalPaths)
        let request = try createURLRequest(method: .POST, url: url, bodyData: bodyData)
        try await run(request: request)
    }
}
