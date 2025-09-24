//
//  NQueensOverviewView.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

import SwiftUI

struct NQueensOverviewView: View {
    var viewModel: NQueensOverviewViewModel
    @EnvironmentObject private var navigation: Navigation

    init(viewModel: NQueensOverviewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                puzzleDescriptionSection
                startNewGameSection
                savedGamesSection
            }
            .padding()
        }
        .navigationTitle("N-Queens Puzzle")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.getBestTime()
        }
    }

    private var puzzleDescriptionSection: some View {
        VStack(spacing: 16) {
            Text("The N-Queens puzzle is a classic problem in computer science and mathematics. The challenge is to place N chess queens on an N×N chessboard so that no two queens threaten each other. This means no two queens can be in the same row, column, or diagonal.")
            
            Text("Best time: " + viewModel.bestTime)
                .font(.headline)
        }
        .font(.body)
        .multilineTextAlignment(.leading)
        .foregroundColor(.primary)
    }

    private var startNewGameSection: some View {
        VStack(spacing: 12) {
            Text("Ready for a new challenge?")
                .font(.headline)

            Button("Start New Game") {
                navigation.navigate(to: .nQueensGame(nil))
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .navigate()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var savedGamesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Saved Games")
                .font(.title2)
                .fontWeight(.semibold)

            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView("Loading saved games...")
                    .frame(maxWidth: .infinity)
                    .padding()
            case .data(let savedGames):
                if savedGames.isEmpty {
                    emptyStateView
                } else {
                    savedGamesList(savedGames)
                }
            case .error(let error):
                errorView(error)
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "gamecontroller")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No saved games yet")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Start a new game to begin your N-Queens journey!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }

    private func savedGamesList(_ savedGames: [NQGameStateItem]) -> some View {
        LazyVStack(spacing: 12) {
            ForEach(savedGames) { savedGame in
                savedGameRow(savedGame)
                    .onTapGesture {
                        navigation.navigate(to: .nQueensGame(savedGame.state))
                    }
            }
        }
        .navigate()
    }

    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red)

            Text("Error loading games")
                .font(.headline)
                .foregroundColor(.primary)

            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Retry") {
                // Could add retry functionality here
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }

    private func savedGameRow(_ savedGame: NQGameStateItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(savedGame.state.name)
                    .font(.headline)

                HStack {
                    Text("\(savedGame.state.size)×\(savedGame.state.size) board")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("\(savedGame.state.placedFigures.count)/\(savedGame.state.size) queens")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack {
                if savedGame.state.placedFigures.count == savedGame.state.size {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                } else {
                    Text("In Progress")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview("Data State") {
    NavigationView {
        NQueensOverviewView(
            viewModel: MockNQueensOverviewViewModel(state: .data([
                NQGameStateItem(
                    state: GameState(
                        size: 8,
                        placedFigures: [FigurePosition(position: Position(row: 0, column: 0), figure: .queen),
                                        FigurePosition(position: Position(row: 1, column: 2), figure: .queen),
                                        FigurePosition(position: Position(row: 2, column: 5), figure: .queen)],
                        name: "8 - In Progress",
                        remainingFigures: [.queen : 5],
                        canReset: true,
                        isSolved: false,
                        time: 65.2
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
                        name: "6 - Completed",
                        remainingFigures: [.queen : 0],
                        canReset: true,
                        isSolved: true,
                        time: 156.8
                    )
                ),
                NQGameStateItem(
                    state: GameState(
                        size: 10,
                        placedFigures: [FigurePosition(position: Position(row: 0, column: 0), figure: .queen),
                                        FigurePosition(position: Position(row: 1, column: 2), figure: .queen)],
                        name: "10 - Challenge",
                        remainingFigures: [.queen : 8],
                        canReset: true,
                        isSolved: false,
                        time: 47.1
                    )
                )
            ]))
        )
    }
}

private class MockNQueensOverviewViewModel: NQueensOverviewViewModel {
    init(state: State) {
        super.init(nQueensRepo: NQueensRepoUseCaseMock(), scoreUseCase: ScoreUseCaseImpl(localRepo: LocalRepoImpl()))
        self.state = state
    }
}

private enum MockError: Error, LocalizedError {
    case loadingFailed

    var errorDescription: String? {
        switch self {
        case .loadingFailed:
            return "Failed to load saved games from storage"
        }
    }
}

