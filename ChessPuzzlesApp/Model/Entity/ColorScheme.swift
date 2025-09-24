//
//  ColorScheme.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 23. 9. 2025..
//

import SwiftUI

enum ColorScheme: Int {
    case classic
    case brown
    
    var colors: (Color, Color) {
        switch self {
        case .classic:
            return (.white, .black)
        case .brown:
            return (.brown.opacity(0.3), .brown)
        }
    }
}
