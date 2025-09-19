//
//  NQueensGameUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

protocol NQueensGameUseCase {
    func start(size: Int) -> NQueensGameState
    func continueGame(_ game: NQueensGameState)
    func putQueen(at row: Int, column: Int) -> NQueensGameState
    func undo() -> NQueensGameState
}
