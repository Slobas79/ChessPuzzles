//
//  ChessBoardViewModel.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 21. 9. 2025..
//

import Foundation

@Observable
class ChessBoardViewModel {
    let size: Int
    private(set) var figures: [Position : Figure]

    init(size: Int, positions: [FigurePosition]) {
        self.size = size
        self.figures = Dictionary(uniqueKeysWithValues: positions.map { ($0.position, $0.figure) })
    }
    
    private var selectedPosition: Position?
    
    func selectFigure(at position: Position) {
        selectedPosition = position
    }
    
    func makeMove(to: Position) {
        if let from = selectedPosition {
            // move
        } else {
            // place
        }
    }
}
