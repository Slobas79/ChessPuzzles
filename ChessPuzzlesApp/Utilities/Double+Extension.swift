//
//  Double+Extension.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 24. 9. 2025..
//

extension Double {
    func formatTime() -> String {
        let minutes = Int(self) / 60
        let remainingSeconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
