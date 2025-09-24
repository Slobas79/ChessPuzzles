//
//  NQueensOverviewViewModel.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

import Foundation

struct NQGameStateItem: Identifiable {
    var id: UUID = UUID()
    let state: GameState
}

@Observable
class NQueensOverviewViewModel {
    enum State {
        case idle
        case loading
        case data([NQGameStateItem])
        case error(Error)
    }

    var state: State = .idle

    private let nQueensRepo: NQueensRepoUseCase

    init(nQueensRepo: NQueensRepoUseCase) {
        self.nQueensRepo = nQueensRepo
        loadSavedGames()
    }

    func startNewGame() {
        
    }

    func loadGame(_ savedGame: NQGameStateItem) {
    }

    func deleteGame(_ savedGame: NQGameStateItem) {
        guard case .data(let savedGames) = state else { return }
        let updatedGames = savedGames.filter { $0.id != savedGame.id }
        state = .data(updatedGames)
    }

    private func loadSavedGames() {
        state = .loading
        let mockGames = createMockSavedGames()
        state = .data(mockGames)
    }

    private func createMockSavedGames() -> [NQGameStateItem] {
        [
            NQGameStateItem(
                state: GameState(
                    size: 8,
                    placedFigures: [FigurePosition(position: Position(row: 0, column: 0), figure: .queen),
                                    FigurePosition(position: Position(row: 1, column: 2), figure: .queen),
                                    FigurePosition(position: Position(row: 2, column: 5), figure: .queen)],
                    name: "8x8 - In Progress",
                    remainingFigures: [.queen : 5],
                    canReset: true,
                    isSolved: false,
                    time: 120.5
                )
            ),
            NQGameStateItem(
                state: GameState(
                    size: 6,
                    placedFigures: [FigurePosition(position: Position(row: 0, column: 1), figure: .queen),
                                    FigurePosition(position: Position(row: 1, column: 3), figure: .queen),
                                    FigurePosition(position: Position(row: 2, column: 5), figure: .queen),
                                    FigurePosition(position: Position(row: 3, column: 0), figure: .queen),
                                    FigurePosition(position: Position(row: 4, column: 2), figure: .queen),
                                    FigurePosition(position: Position(row: 5, column: 4), figure: .queen)],
                    name: "6x6 - Completed",
                    remainingFigures: [.queen : 0],
                    canReset: true,
                    isSolved: true,
                    time: 89.3
                )
            ),
            NQGameStateItem(
                state: GameState(
                    size: 10,
                    placedFigures: [FigurePosition(position: Position(row: 0, column: 0), figure: .queen),
                                    FigurePosition(position: Position(row: 1, column: 2), figure: .queen),
                                    FigurePosition(position: Position(row: 2, column: 5), figure: .queen),
                                    FigurePosition(position: Position(row: 3, column: 7), figure: .queen),
                                    FigurePosition(position: Position(row: 4, column: 9), figure: .queen)],
                    name: "10x10 - Challenge",
                    remainingFigures: [.queen : 5],
                    canReset: true,
                    isSolved: false,
                    time: 245.7
                )
            )
        ]
    }
}

