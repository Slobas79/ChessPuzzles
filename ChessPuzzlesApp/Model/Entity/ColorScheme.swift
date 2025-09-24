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
    
    //           light  dark   figure
    var colors: (Color, Color, Color) {
        switch self {
        case .classic:
            return (.white, .black, .gray)
        case .brown:
            return (.brown.opacity(0.3), .brown.opacity(0.7), .brown)
        }
    }
}
