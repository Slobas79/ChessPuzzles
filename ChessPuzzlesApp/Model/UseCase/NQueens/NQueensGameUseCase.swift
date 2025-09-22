//
//  NQueensGameUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

protocol NQueensGameUseCase {
//    func start(size: Int) -> GameState
//    func continueGame(_ game: GameState)
    func putQueen(at row: Int, column: Int) -> GameState
    func undo() -> GameState
}
