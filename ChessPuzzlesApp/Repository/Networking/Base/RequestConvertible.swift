//
//  RequestConvertible.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

import Foundation

protocol RequestConvertible {
    func toURLRequest() throws -> URLRequest
}
