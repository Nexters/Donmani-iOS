//
//  NetworkService.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    var baseURL = "https://jsonplaceholder.typicode.com/posts/1"

    
    private init() {}

    func request<T: Decodable>(
        method: HTTPMethod = .GET,
        parameters: [String: Any]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network request failed: \(error)")
                completion(.failure(.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Decoding failed: \(error)")
                completion(.failure(.decodingFailed))
            }
        }
        
        task.resume()
    }
}
