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
        if viewModel.boardViewModel?.isSolved ?? false {
            congratsView
        } else {
            switch viewModel.screenState {
            case .newGame(let minimumSize):
                newGameView(minimumSize: minimumSize)
            case .gameInProgress:
                gameInProgressView
            }
        }
    }

    private var congratsView: some View {
        ZStack {
            // Background gradient
            AnimatedBackgroundGradient()
                .ignoresSafeArea()

            // Confetti particles
            ForEach(0..<20, id: \.self) { index in
                ConfettiParticle(delay: Double(index) * 0.1)
            }

            VStack(spacing: 24) {
                // Crown icon
                Image(systemName: "crown.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .scaleEffect(1.2)
                    .animation(.spring(response: 0.8, dampingFraction: 0.3).delay(0.3), value: viewModel.boardViewModel?.isSolved)

                // Main congratulations text
                Text("Congratulations!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue, .green],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(1.1)
                    .animation(.spring(response: 0.6, dampingFraction: 0.4).delay(0.5), value: viewModel.boardViewModel?.isSolved)

                // Secondary text
                Text("You solved the N-Queens puzzle!")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .opacity(0.8)
                    .scaleEffect(0.9)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.7), value: viewModel.boardViewModel?.isSolved)

                // Star ratings
                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { index in
                        AnimatedStar(index: index, isSolved: viewModel.boardViewModel?.isSolved ?? false)
                    }
                }

                // Celebration icons
                HStack(spacing: 20) {
                    Image(systemName: "party.popper.fill")
                        .font(.title)
                        .foregroundColor(.red)
                        .scaleEffect(1.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.3).delay(1.4), value: viewModel.boardViewModel?.isSolved)

                    Image(systemName: "trophy.fill")
                        .font(.title)
                        .foregroundColor(.yellow)
                        .scaleEffect(1.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.3).delay(1.6), value: viewModel.boardViewModel?.isSolved)

                    Image(systemName: "party.popper.fill")
                        .font(.title)
                        .foregroundColor(.red)
                        .scaleEffect(1.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.3).delay(1.8), value: viewModel.boardViewModel?.isSolved)
                        .scaleEffect(x: -1) // Flip horizontally
                }
            }
            .padding()
        }
        .transition(.scale.combined(with: .opacity))
        .animation(.spring(response: 0.8, dampingFraction: 0.6), value: viewModel.boardViewModel?.isSolved)
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

// MARK: - Confetti Particle Component
struct ConfettiParticle: View {
    let delay: Double
    @State private var animate = false
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = -50
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0

    // Pre-computed random values to avoid issues with animations
    private let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink]
    private let shapes = ["circle.fill", "star.fill", "heart.fill", "diamond.fill"]
    private let randomShape: String
    private let randomSize: CGFloat
    private let randomColor: Color
    private let randomXMovement: CGFloat
    private let randomInitialRotation: Double

    init(delay: Double) {
        self.delay = delay
        self.randomShape = ["circle.fill", "star.fill", "heart.fill", "diamond.fill"].randomElement() ?? "circle.fill"
        self.randomSize = CGFloat.random(in: 8...16)
        self.randomColor = [Color.red, .blue, .green, .yellow, .purple, .orange, .pink].randomElement() ?? .blue
        self.randomXMovement = CGFloat.random(in: -100...100)
        self.randomInitialRotation = Double.random(in: 0...360)
    }

    var body: some View {
        GeometryReader { geometry in
            Image(systemName: randomShape)
                .font(.system(size: randomSize))
                .foregroundColor(randomColor)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .offset(x: xOffset, y: yOffset)
                .position(x: geometry.size.width / 2, y: 0)
                .onAppear {
                    startAnimation(screenHeight: geometry.size.height)
                }
        }
    }

    private func startAnimation(screenHeight: CGFloat) {
        // Set initial rotation
        rotation = randomInitialRotation

        // Delayed start
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeOut(duration: 0.3)) {
                scale = 1.0
            }

            // Falling animation
            withAnimation(.easeIn(duration: 3.0)) {
                yOffset = screenHeight + 100
            }

            // Side-to-side movement
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                xOffset = randomXMovement
            }

            // Rotation
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotation += 360
            }

            // Scale pulsing - using a fixed range instead of random
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                scale = 1.3
            }
        }
    }
}

// MARK: - Animated Background Gradient
struct AnimatedBackgroundGradient: View {
    @State private var animateGradient = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.purple.opacity(0.3),
                Color.blue.opacity(0.3),
                Color.green.opacity(0.3)
            ]),
            startPoint: animateGradient ? .topLeading : .bottomTrailing,
            endPoint: animateGradient ? .bottomTrailing : .topLeading
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

// MARK: - Animated Star Component
struct AnimatedStar: View {
    let index: Int
    let isSolved: Bool
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0

    var body: some View {
        Image(systemName: "star.fill")
            .font(.title2)
            .foregroundColor(.yellow)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                // Initial appearance animation
                withAnimation(
                    .spring(response: 0.5, dampingFraction: 0.4)
                    .delay(0.9 + Double(index) * 0.1)
                ) {
                    scale = 1.3
                }

                // Continuous rotation
                withAnimation(
                    .linear(duration: 3.0)
                    .repeatForever(autoreverses: false)
                    .delay(0.9 + Double(index) * 0.1)
                ) {
                    rotation = 360
                }
            }
            .onChange(of: isSolved) { newValue in
                if newValue {
                    withAnimation(
                        .spring(response: 0.5, dampingFraction: 0.4)
                        .delay(0.9 + Double(index) * 0.1)
                    ) {
                        scale = 1.3
                    }
                }
            }
    }
}

#Preview {
    NQueensGameView(viewModel: NQueensGameViewModel(validationUseCase: NQueensValidationUseCaseImpl(),
                                                    nQueensUseCase: NQueensGameUseCase(),
                                                    state: GameState(size: 8,
                                                                     placedFigures: [
                                                                        FigurePosition(position: Position(row: 1, column: 2), figure: .queen)],
                                                                     name: "",
                                                                     remainingFigures: [.queen : 7],
                                                                     canReset: true,
                                                                     isSolved: false)))
}
