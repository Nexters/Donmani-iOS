//
//  NetworkError.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case serverError(statusCode: Int)
}
