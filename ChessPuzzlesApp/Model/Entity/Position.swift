//
//  FigurePosition.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

struct FigurePosition: Codable, Equatable, Hashable {
    let position: Position
    let figure: Figure
}

struct Position: Codable, Equatable, Hashable {
    let row: Int
    let column: Int
}
