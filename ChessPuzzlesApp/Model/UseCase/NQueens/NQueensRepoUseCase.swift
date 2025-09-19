//
//  NQueensRepoUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

protocol NQueensRepoUseCase {
    func load() -> [NQueensGameState]
    func save(state: NQueensGameState)
    func delete(state: NQueensGameState)
}

final class NQueensRepoUseCaseImpl: NQueensRepoUseCase {
    func load() -> [NQueensGameState] {
        var states: [NQueensGameState] = [
            NQueensGameState(
                size: 8,
                placedQueens: [Position(row: 0, column: 0), Position(row: 1, column: 2), Position(row: 2, column: 5)],
                name: "8x8 - In Progress"
            ),
            NQueensGameState(
                size: 6,
                placedQueens: [Position(row: 0, column: 1), Position(row: 1, column: 3), Position(row: 2, column: 5), Position(row: 3, column: 0), Position(row: 4, column: 2), Position(row: 5, column: 4)],
                name: "6x6 - Completed"
            ),
            NQueensGameState(
                size: 10,
                placedQueens: [Position(row: 0, column: 0), Position(row: 1, column: 2), Position(row: 2, column: 5), Position(row: 3, column: 7), Position(row: 4, column: 9)],
                name: "10x10 - Challenge"
            )
        ]
        return states
    }
    
    func save(state: NQueensGameState) {
        
    }
    
    func delete(state: NQueensGameState) {
        
    }
}
