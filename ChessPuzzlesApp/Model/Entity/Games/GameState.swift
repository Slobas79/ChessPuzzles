//
//  GameState.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

struct GameState: Codable, Equatable, Hashable {
    let size: Int
    let placedFigures: [FigurePosition]
    let name: String
    let remainingFigures: [Figure : Int]?
    let canReset: Bool
    let isSolved: Bool = false
}
