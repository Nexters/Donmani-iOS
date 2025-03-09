//
//  DNetworkService.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation

public final class DNetworkService {
    public static let shared = DNetworkService()
    
    private let baseURL = DURLManager.api.urlString
    
    private init() {
        
    }
    
    func getURLReqeust(method: HTTPMethod, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    public func requestAppVersion<T: Codable>() async throws -> T  {
        guard let url = URL(string: DURLManager.appInfo.urlString) else {
            throw NetworkError.invalidURL
        }
        let request = getURLReqeust(method: .GET, url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        let stateCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        if stateCode >= 400 {
            throw NetworkError.serverError(statusCode: stateCode)
        }
        
        guard let returnData = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingFailed
        }
        return returnData
    }

    public func requestGET<T: Codable>(
        path: DPath,
        addtionalPath: [String] = [],
        parameters: [String: Any]? = nil
    ) async throws -> T {
        guard var url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        url.append(path: path.rawValue)
        for addtional in addtionalPath {
            url.append(path: addtional)
        }
        
        if let parameters = parameters {
            if var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
                components.queryItems = parameters.map { item in
                    URLQueryItem(name: item.key, value: String(describing: item.value))
                }
                url = components.url ?? url
            }
        }
        let request = getURLReqeust(method: .GET, url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        let stateCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        if stateCode >= 400 {
            throw NetworkError.serverError(statusCode: stateCode)
        }
        
        guard let returnData = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingFailed
        }
        return returnData
    }
    
    public func requestPOST<T: Codable, R: Codable>(
        path: DPath,
        addtionalPath: [String] = [],
        bodyData: T
    ) async throws -> R? {
        guard var url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        url.append(path: path.rawValue)
        for addtional in addtionalPath {
            url.append(path: addtional)
        }
        
        guard let body = try? JSONEncoder().encode(bodyData) else {
            throw NetworkError.encodingFailed
        }
        
        var request = getURLReqeust(method: .POST, url: url)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let stateCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        if stateCode != 200 {
            throw NetworkError.serverError(statusCode: stateCode)
        }
        
        if data.count == 0 {
            return nil
        }
        
        guard let responseData = try? JSONDecoder().decode(R.self, from: data) else {
            throw NetworkError.decodingFailed
        }
        return responseData
    }
    
    public func requestPUT<T: Codable, R: Codable> (
        path: DPath,
        addtionalPath: [String] = [],
        bodyData: T
    ) async throws -> R {
        guard var url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        url.append(path: path.rawValue)
        for addtional in addtionalPath {
            url.append(path: addtional)
        }
        
        guard let body = try? JSONEncoder().encode(bodyData) else {
            throw NetworkError.encodingFailed
        }
        
        var request = getURLReqeust(method: .PUT, url: url)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let stateCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        if stateCode >= 400 {
            throw NetworkError.serverError(statusCode: stateCode)
        }
        
        guard let responseData = try? JSONDecoder().decode(R.self, from: data) else {
            throw NetworkError.decodingFailed
        }
        
        return responseData
    }
}
