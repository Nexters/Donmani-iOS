//
//  NetworkRequest+PUT.swift
//  DNetwork
//
//  Created by 문종식 on 7/26/25.
//

extension NetworkRequest {
    /// PUT Request with Decodable Response
    func put<T: Encodable, R: Decodable>(
        path: APIPath?,
        addtionalPaths: [String]? = nil,
        bodyData: T?
    ) async throws -> R {
        let url = try createURL(path, addtionalPaths)
        let request = try createURLReqeust(method: .PUT, url: url, bodyData: bodyData)
        return try await run(request: request)
    }
    
    /// PUT Request with Empty Request
    func put<R: Decodable>(
        path: APIPath?,
        addtionalPaths: [String]? = nil
    ) async throws -> R {
        let url = try createURL(path, addtionalPaths)
        let request = createURLReqeust(method: .PUT, url: url)
        return try await run(request: request)
    }
}
