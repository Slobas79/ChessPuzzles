//
//  PuzzlesView.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

import SwiftUI

struct PuzzlesView: View {
    @EnvironmentObject private var navigation: Navigation

    private let puzzles: [Puzzles] = [.nQueens]

    var body: some View {
        NavigationStack(path: $navigation.path) {
            List {
                ForEach(puzzles, id: \.self) { puzzle in
                    puzzleRow(for: puzzle)
                        .onTapGesture {
                            navigation.navigate(to: puzzle.screen)
                        }
                }
            }
            .navigationTitle("Puzzles")
            .navigationBarTitleDisplayMode(.large)
            .navigate()
        }
    }

    private func puzzleRow(for puzzle: Puzzles) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(puzzle.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(puzzle.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)

                Text("Difficulty: \(puzzle.difficulty)")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(puzzle.difficultyColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Spacer()

            Image(systemName: puzzle.iconName)
                .font(.title2)
                .foregroundColor(.accentColor)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    PuzzlesView()
        .environmentObject(Navigation(factory: ScreenFactory(container: DependencyInjectionContainer())))
}

