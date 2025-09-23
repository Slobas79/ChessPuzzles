//
//  Figure.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 21. 9. 2025..
//

enum Figure: Codable, Comparable {
    case queen
    
    var iconName: String {
        switch self {
        case .queen:
            return "crown.fill"
        }
    }
}
