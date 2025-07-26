//
//  NetworkError.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

public enum NetworkError: Error {
    case invalidURL
    case invalidURLString
    case requestFailed
    case noData
    case decodingFailed
    case encodingFailed
    case serverError(statusCode: Int)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidURLString:
            return "Invalid URL String"
        case .requestFailed:
            return "Request failed"
        case .noData:
            return "No data returned"
        case .decodingFailed:
            return "Decoding failed"
        case .encodingFailed:
            return "Encoding failed"
        case .serverError(statusCode: let code):
            return "Server error (\(code))"
        }
    }
}
