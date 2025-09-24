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
    @State private var congratsOpacity: Double = 0.0
    @State private var showCongrats: Bool = false

    var body: some View {
        content
            .navigationTitle("N-Queens Puzzle")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.updateSettings()
            }
    }

    @ViewBuilder
    private var content: some View {
        ZStack {
            switch viewModel.screenState {
            case .newGame(let minimumSize):
                newGameView(minimumSize: minimumSize)
            case .gameInProgress:
                gameInProgressView
            }

            if showCongrats {
                congratsView()
                    .opacity(congratsOpacity)
            }
        }
        .onChange(of: viewModel.boardViewModel?.isSolved ?? false) { _, isSolved in
            if isSolved && !showCongrats {
                showCongrats = true

                // Fade in
                withAnimation(.easeIn(duration: 0.5)) {
                    congratsOpacity = 1.0
                }
                
                // Fade out after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        congratsOpacity = 0.0
                    }

                    // Hide the view after fade out completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showCongrats = false
                    }
                }
            }
        }
    }
    
    private var gameInProgressView: some View {
        VStack(spacing: 16) {
            HStack {
                if let figures = viewModel.boardViewModel?.remainingFigures {
                    HStack(spacing: 8) {
                        ForEach(figures.keys.sorted(by:{$0 > $1}), id: \.self) { key in
                            HStack(spacing: 4) {
                                Text("\(figures[key] ?? 0)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: figures[key])
                                Image(systemName: key.iconName)
                                    .foregroundColor(.blue)
                                    .font(.title3)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .scaleEffect(figures[key] == 0 ? 0.9 : 1.0)
                            .opacity(figures[key] == 0 ? 0.6 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: figures[key])
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }

                Spacer()

                if viewModel.boardViewModel?.canReset ?? false {
                    Button(action: {
                        viewModel.resetGame()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.boardViewModel?.canReset)
                }
            }
            .padding(.horizontal)

            GeometryReader { geometry in
                if let boardViewModel = viewModel.boardViewModel {
                    let cellSize: CGFloat = 40.0
                    let boardSize = CGFloat(boardViewModel.size + 1) * cellSize + 32 // +32 for padding
                    let availableWidth = geometry.size.width
                    let availableHeight = geometry.size.height
                    let boardFits = boardSize <= availableWidth && boardSize <= availableHeight

                    Group {
                        if boardFits {
                            // Board fits, no ScrollView needed
                            VStack {
                                ChessBoardView(viewModel: boardViewModel)
                                    .scaleEffect(1.0)
                                    .animation(.easeInOut(duration: 0.4), value: boardViewModel.size)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .transition(.scale.combined(with: .opacity))
                        } else {
                            // Board doesn't fit, use ScrollView
                            ScrollView([.horizontal, .vertical]) {
                                ChessBoardView(viewModel: boardViewModel)
                                    .scaleEffect(1.0)
                                    .animation(.easeInOut(duration: 0.4), value: boardViewModel.size)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: boardFits)
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.boardViewModel?.remainingFigures)
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
                                                    settingsUseCase: SettingsUseCaseImpl(localRepo: LocalRepoImpl()),
                                                    state: GameState(size: 8,
                                                                     placedFigures: [
                                                                        FigurePosition(position: Position(row: 1, column: 2), figure: .queen)],
                                                                     name: "",
                                                                     remainingFigures: [.queen : 7],
                                                                     canReset: true,
                                                                     isSolved: false)))
}
