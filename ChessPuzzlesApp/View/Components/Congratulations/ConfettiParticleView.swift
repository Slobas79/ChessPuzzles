//
//  ConfettiParticleView.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 24. 9. 2025..
//

import SwiftUI


struct ConfettiParticleView: View {
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
