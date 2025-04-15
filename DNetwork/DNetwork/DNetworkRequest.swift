//
//  DNetworkService.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation

public struct DNetworkRequest {
    private var apiBaseURL: String = DURL.api.urlString
    
    public init() {
        
    }
    
    private func createURLReqeust(method: HTTPMethod, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func createURL(baseURL: String) throws -> URL {
        guard var url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
//    public func requestAppVersion<T: Codable>() async throws -> T  {
//        guard let url = URL(string: DURL.appInfo.urlString) else {
//            throw NetworkError.invalidURL
//        }
//        let request = createURLReqeust(method: .GET, url: url)
//        let (data, response) = try await URLSession.shared.data(for: request)
//        let stateCode = (response as? HTTPURLResponse)?.statusCode ?? 500
//        if stateCode >= 400 {
//            throw NetworkError.serverError(statusCode: stateCode)
//        }
//        
//        guard let returnData = try? JSONDecoder().decode(T.self, from: data) else {
//            throw NetworkError.decodingFailed
//        }
//        return returnData
//    }
    
    private func run<R: Codable>(request: URLRequest) async throws -> R {
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
        guard let returnData = try? JSONDecoder().decode(R.self, from: data) else {
            throw NetworkError.decodingFailed
        }
        return returnData
    }
}


// Get Request
extension DNetworkRequest {
    public func get<R: Codable>(
        urlString: String,
        addtionalPath: [String] = [],
        parameters: [String: Any]? = nil
    ) async throws -> R {
        var url = try createURL(baseURL: urlString)
        url.add(paths: addtionalPath)
        if let parameters {
            url = url.addQueryItems(parameters: parameters)
        }
        return try await get(url: url)
    }
    
    func get<R: Codable>(
        url: URL
    ) async throws -> R {
        let request = createURLReqeust(method: .GET, url: url)
        return try await run(request: request)
    }
    
    public func get<R: Codable>(
        path: DPath,
        addtionalPath: [String] = [],
        parameters: [String: Any]? = nil
    ) async throws -> R {
        var url = try createURL(baseURL: DURL.api.urlString)
        url.add(paths: [path.rawValue])
        url.add(paths: addtionalPath)
        if let parameters {
            url = url.addQueryItems(parameters: parameters)
        }
        return try await get(url: url)
    }
}


// Post Request
extension DNetworkRequest {
    public func post<T: Codable, R: Codable>(
        urlString: String,
        addtionalPath: [String] = [],
        bodyData: T?
    ) async throws -> R {
        var url = try createURL(baseURL: urlString)
        url.add(paths: addtionalPath)
        return try await post(url: url, bodyData: bodyData)
    }
    
    func post<T: Codable, R: Codable>(
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
    
    public func post<T: Codable, R: Codable>(
        path: DPath,
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
    public func put<T: Codable, R: Codable>(
        urlString: String,
        addtionalPath: [String] = [],
        bodyData: T?
    ) async throws -> R {
        var url = try createURL(baseURL: urlString)
        url.add(paths: addtionalPath)
        return try await post(url: url, bodyData: bodyData)
    }
    
    func put<T: Codable, R: Codable>(
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
    
    public func put<T: Codable, R: Codable>(
        path: DPath,
        addtionalPath: [String] = [],
        bodyData: T?
    ) async throws -> R {
        var url = try createURL(baseURL: DURL.api.urlString)
        url.add(paths: [path.rawValue])
        url.add(paths: addtionalPath)
        return try await post(url: url, bodyData: bodyData)
    }
}
