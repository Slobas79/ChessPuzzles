//
//  NQueensRepoUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

protocol NQueensRepoUseCase {
    func load() -> [GameState]
    func save(state: GameState)
    func delete(state: GameState)
}

final class NQueensRepoUseCaseMock: NQueensRepoUseCase {
    func load() -> [GameState] {
        var states: [GameState] = [
            GameState(
                size: 8,
                placedFigures: [FigurePosition(position: Position(row: 0, column: 0), figure: .queen),
                                FigurePosition(position: Position(row: 1, column: 2), figure: .queen),
                                FigurePosition(position: Position(row: 2, column: 5), figure: .queen)],
                name: "8 - In Progress",
                remainingFigures: [.queen : 5],
                canReset: true,
                isSolved: false,
                time: 132.0
            ),
            GameState(
                size: 6,
                placedFigures: [FigurePosition(position: Position(row: 0, column: 1), figure: .queen),
                                FigurePosition(position: Position(row: 1, column: 3), figure: .queen),
                                FigurePosition(position: Position(row: 2, column: 5), figure: .queen),
                                FigurePosition(position: Position(row: 3, column: 0), figure: .queen),
                                FigurePosition(position: Position(row: 4, column: 2), figure: .queen),
                                FigurePosition(position: Position(row: 5, column: 4), figure: .queen)],
                name: "6 - Completed",
                remainingFigures: [.queen : 0],
                canReset: true,
                isSolved: true,
                time: 78.0
            ),
            GameState(
                size: 10,
                placedFigures: [FigurePosition(position: Position(row: 0, column: 0), figure: .queen),
                                FigurePosition(position: Position(row: 1, column: 2), figure: .queen),
                                FigurePosition(position: Position(row: 2, column: 5), figure: .queen),
                                FigurePosition(position: Position(row: 3, column: 7), figure: .queen),
                                FigurePosition(position: Position(row: 4, column: 9), figure: .queen)],
                name: "10 - Challenge",
                remainingFigures: [.queen : 5],
                canReset: true,
                isSolved: false,
                time: 298.0
            )
        ]
        return states
    }

    func save(state: GameState) {

    }

    func delete(state: GameState) {

    }
}
