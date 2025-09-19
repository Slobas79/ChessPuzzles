//
//  NQueensOverviewViewModel.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

import Foundation

struct NQGameStateItem: Identifiable {
    var id: UUID = UUID()
    let state: NQueensGameState
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
                state: NQueensGameState(
                    size: 8,
                    placedQueens: [Position(row: 0, column: 0), Position(row: 1, column: 2), Position(row: 2, column: 5)],
                    name: "8x8 - In Progress"
                )
            ),
            NQGameStateItem(
                state: NQueensGameState(
                    size: 6,
                    placedQueens: [Position(row: 0, column: 1), Position(row: 1, column: 3), Position(row: 2, column: 5), Position(row: 3, column: 0), Position(row: 4, column: 2), Position(row: 5, column: 4)],
                    name: "6x6 - Completed"
                )
            ),
            NQGameStateItem(
                state: NQueensGameState(
                    size: 10,
                    placedQueens: [Position(row: 0, column: 0), Position(row: 1, column: 2), Position(row: 2, column: 5), Position(row: 3, column: 7), Position(row: 4, column: 9)],
                    name: "10x10 - Challenge"
                )
            )
        ]
    }
}

