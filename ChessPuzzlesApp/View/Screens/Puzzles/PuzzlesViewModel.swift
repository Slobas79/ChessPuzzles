//
//  PuzzlesViewModel.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

import SwiftUI

extension Puzzles {
    
    var screen: Screen {
        switch self {
        case .nQueens:
            return .nQueensOverview
        }
    }
    
    var title: String {
        switch self {
        case .nQueens:
            return "N-Queens"
        }
    }

    var description: String {
        switch self {
        case .nQueens:
            return "Place N queens on an N×N chessboard so that no two queens threaten each other."
        }
    }

    var difficulty: String {
        switch self {
        case .nQueens:
            return "Medium"
        }
    }

    var difficultyColor: Color {
        switch self {
        case .nQueens:
            return .orange
        }
    }

    var iconName: String {
        switch self {
        case .nQueens:
            return "crown.fill"
        }
    }
}
