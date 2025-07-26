//
//  URL+Extension.swift
//  DNetwork
//
//  Created by 문종식 on 4/15/25.
//

import Foundation

extension URL {
    mutating func add(paths: [String]) {
        for path in paths {
            self.append(path: path)
        }
    }
    
    func addQueryItems(parameters: [String: Any]) throws -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = parameters.map { item in
            URLQueryItem(name: item.key, value: String(describing: item.value))
        }
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
}
