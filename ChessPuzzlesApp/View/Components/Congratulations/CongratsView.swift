//
//  CongratsView.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 24. 9. 2025..
//

import SwiftUI

@ViewBuilder
func congratsView() -> some View {
    ZStack {
        // Background gradient
        AnimatedBackgroundGradientView()
            .ignoresSafeArea()

        // Confetti particles
        ForEach(0..<20, id: \.self) { index in
            ConfettiParticleView(delay: Double(index) * 0.1)
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
                .animation(.spring(response: 0.8, dampingFraction: 0.3).delay(0.3), value: true)

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
                .animation(.spring(response: 0.6, dampingFraction: 0.4).delay(0.5), value: true)

            // Secondary text
            Text("You solved the N-Queens puzzle!")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .opacity(0.8)
                .scaleEffect(0.9)
                .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.7), value: true)

            // Star ratings
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { index in
                    AnimatedStarView(index: index, isSolved: true)
                }
            }

            // Celebration icons
            HStack(spacing: 20) {
                Image(systemName: "party.popper.fill")
                    .font(.title)
                    .foregroundColor(.red)
                    .scaleEffect(1.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.3).delay(1.4), value: true)

                Image(systemName: "trophy.fill")
                    .font(.title)
                    .foregroundColor(.yellow)
                    .scaleEffect(1.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.3).delay(1.6), value: true)

                Image(systemName: "party.popper.fill")
                    .font(.title)
                    .foregroundColor(.red)
                    .scaleEffect(1.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.3).delay(1.8), value: true)
                    .scaleEffect(x: -1) // Flip horizontally
            }
        }
        .padding()
    }
    .transition(.scale.combined(with: .opacity))
    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: true)
}
