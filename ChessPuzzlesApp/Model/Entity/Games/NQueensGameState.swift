//
//  NQueensGameState.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

struct NQueensGameState: Codable {
    let size: Int
    let placedQueens: [Position]
    let name: String
}
