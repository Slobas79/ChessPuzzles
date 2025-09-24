//
//  AnimatedStarView.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 24. 9. 2025..
//

import SwiftUI

struct AnimatedStarView: View {
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
