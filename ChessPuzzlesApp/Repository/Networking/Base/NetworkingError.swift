//
//  NetworkingError.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

enum NetworkingError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
    case deserializationError
    case unknownError
}
