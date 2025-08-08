//
//  NetworkRequest.swift
//  DNetwork
//
//  Created by 문종식 on 7/27/25.
//

public struct NetworkRequest {
    private var apiBaseURL: String {
        DURL.api.urlString
    }
    
    public init() { }
    
    func createURL(
        _ path: APIPath?,
        _ addtionalPaths: [String]?,
        _ parameters: [String: Any]? = nil
    ) throws -> URL {
        guard var url = URL(string: apiBaseURL) else {
            throw NetworkError.invalidURLString
        }
        if let path {
            url.add(paths: [path.rawValue])
        }
        if let addtionalPaths {
            url.add(paths: addtionalPaths)
        }
        if let parameters {
            url = try url.addQueryItems(parameters: parameters)
        }
        return url
    }
    
    func createURL(
        _ urlString: String,
        _ addtionalPaths: [String]?,
        _ parameters: [String: Any]? = nil
    ) throws -> URL {
        guard var url = URL(string: urlString) else {
            throw NetworkError.invalidURLString
        }
        if let addtionalPaths {
            url.add(paths: addtionalPaths)
        }
        if let parameters {
            url = try url.addQueryItems(parameters: parameters)
        }
        return url
    }
    
    func createURLReqeust(
        method: HTTPMethod,
        url: URL
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "accept")
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func createURLReqeust<T: Encodable>(
        method: HTTPMethod,
        url: URL,
        bodyData: T?
    ) throws -> URLRequest {
        var request = createURLReqeust(method: method, url: url)
        if let bodyData {
            guard let body = try? JSONEncoder().encode(bodyData) else {
                throw NetworkError.encodingFailed
            }
            request.httpBody = body
        }
        return request
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
    
    /// Request with Raw URL String
    func run(dataRequest: URLRequest) async throws -> Data {
        guard let (data, response) = try? await URLSession.shared.data(for: dataRequest) else {
            throw NetworkError.requestFailed
        }
        let stateCode = (response as? HTTPURLResponse)?.statusCode ?? 500
        if stateCode >= 400 {
            throw NetworkError.serverError(statusCode: stateCode)
        }
        return data
    }
}

