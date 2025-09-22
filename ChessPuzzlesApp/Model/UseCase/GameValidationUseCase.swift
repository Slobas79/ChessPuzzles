//
//  GameValidationUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 22. 9. 2025..
//

protocol GameValidationUseCase {
    func isValid(figure: Figure, position: Position, game: GameState) -> Bool
}
