//
//  ColorScheme.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 23. 9. 2025..
//

import SwiftUI

enum ColorScheme: Int {
    case light
    case dark
    case light1
    case dark1
    
    var color: Color {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        case .light1:
            return .brown.opacity(0.3)
        case .dark1:
            return .brown
        }
    }
}
