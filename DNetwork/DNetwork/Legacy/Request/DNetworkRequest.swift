//
//  DNetworkService.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation

struct DNetworkRequest {
    var apiBaseURL: String {
        DURL.api.urlString
    }
    
    public init() {
        
    }
    
    func createURL(
        _ path: APIPath,
        _ addtionalPaths: [String]?,
        _ parameters: [String: Any]?
    ) throws -> URL {
        guard var url = URL(string: apiBaseURL) else {
            throw NetworkError.invalidURLString
        }
        url.add(paths: [path.rawValue])
        if let addtionalPaths {
            url.add(paths: addtionalPaths)
        }
        if let parameters {
            url = try url.addQueryItems(parameters: parameters)
        }
        return url
    }
    
    func createURLReqeust(method: HTTPMethod, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func createURL(baseURL: String) throws -> URL {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    /// Request With Decodable Response
    func run<R: Decodable>(request: URLRequest) async throws -> R {
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw NetworkError.requestFailed
        }
        let stateCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        if stateCode >= 400 {
            throw NetworkError.serverError(statusCode: stateCode)
        }
        if data.count == 0 {
            let tempResponse = DResponse(statusCode: 200, responseMessage: "Success", responseData: Data())
            return tempResponse as! R
        }
#if DEBUG
        if let debugString = String(data: data, encoding: .utf8) {
            print(debugString)
        }
#endif
        guard let returnData = try? JSONDecoder().decode(R.self, from: data) else {
            throw NetworkError.decodingFailed
        }
        return returnData
    }
    
    /// Request with Empty Response
    func run(request: URLRequest) async throws {
        guard let (_, response) = try? await URLSession.shared.data(for: request) else {
            throw NetworkError.requestFailed
        }
        let stateCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        if stateCode >= 400 {
            throw NetworkError.serverError(statusCode: stateCode)
        }
    }
    
    func runData(request: URLRequest) async throws -> Data {
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw NetworkError.requestFailed
        }
        let stateCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        if stateCode >= 400 {
            throw NetworkError.serverError(statusCode: stateCode)
        }
        return data
    }
}

// Get Request
extension DNetworkRequest {
    public func getData(
        urlString: String
    ) async throws -> Data {
        var url = try createURL(baseURL: urlString)
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

// Post Request
extension DNetworkRequest {
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


// Put Request
extension DNetworkRequest {
    public func put<T: Encodable, R: Decodable>(
        urlString: String,
        addtionalPath: [String] = [],
        bodyData: T?
    ) async throws -> R {
        var url = try createURL(baseURL: urlString)
        url.add(paths: addtionalPath)
        return try await put(url: url, bodyData: bodyData)
    }
    
    func put<T: Encodable, R: Decodable>(
        url: URL,
        bodyData: T?
    ) async throws -> R {
        var request = createURLReqeust(method: .PUT, url: url)
        if let bodyData {
            guard let body = try? JSONEncoder().encode(bodyData) else {
                throw NetworkError.encodingFailed
            }
            request.httpBody = body
        }
        return try await run(request: request)
    }
    
    public func put<T: Encodable, R: Decodable>(
        path: APIPath,
        addtionalPath: [String] = [],
        bodyData: T?
    ) async throws -> R {
        var url = try createURL(baseURL: DURL.api.urlString)
        url.add(paths: [path.rawValue])
        url.add(paths: addtionalPath)
        return try await put(url: url, bodyData: bodyData)
    }
}
