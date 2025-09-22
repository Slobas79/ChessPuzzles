//
//  NQueensGameView.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 20. 9. 2025..
//

import SwiftUI

struct NQueensGameView: View {
    var viewModel: NQueensGameViewModel
    @State private var boardSizeInput: String = ""
    @State private var errorMessage: String?

    var body: some View {
        content
            .navigationTitle("N-Queens Puzzle")
            .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.screenState {
        case .newGame(let minimumSize):
            newGameView(minimumSize: minimumSize)
        case .gameInProgress:
            gameInProgressView
        }
    }

    private var gameInProgressView: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.resetGame()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(.horizontal)

            ScrollView([.horizontal, .vertical]) {
                if let boardViewModel = viewModel.boardViewModel {
                    ChessBoardView(viewModel: boardViewModel)
                }
            }
        }
    }
    
    private func newGameView(minimumSize: Int) -> some View {
        VStack(spacing: 24) {
            Text("Choose Board Size")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Enter the size of your N×N chessboard. The minimum size is \(minimumSize)×\(minimumSize).")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            boardSizeInput(minimumSize: minimumSize)
        }
        .padding()
    }

    private func boardSizeInput(minimumSize: Int) -> some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Board Size")
                    .font(.headline)

                TextField("Enter size (e.g., \(minimumSize))", text: $boardSizeInput)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Button("Start Game") {
                startGame()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .frame(maxWidth: .infinity)
            .disabled(boardSizeInput.isEmpty)
        }
    }

    private func startGame() {
        guard let size = Int(boardSizeInput) else {
            errorMessage = "Please enter a valid number"
            return
        }

        do {
            try viewModel.startNewGame(size: size)
            errorMessage = nil
            boardSizeInput = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    NQueensGameView(viewModel: NQueensGameViewModel(validationUseCase: NQueensValidationUseCaseImpl(),
                                                    nQueensUseCase: NQueensGameUseCase(),
                                                    state: GameState(size: 8,
                                                                     placedFigures: [
                                                                        FigurePosition(position: Position(row: 1, column: 2), figure: .queen)],
                                                                     name: "")))
}
