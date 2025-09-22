//
//  ChessBoardViewModel.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 21. 9. 2025..
//

import Foundation
import Combine

@Observable
class ChessBoardViewModel {
    let useCase: GameUseCase
    let validation: GameValidationUseCase
    let size: Int
    private(set) var figures: [Position : Figure]
    private(set) var invalidPosition: Position?
    private var selectedPosition: Position?
    private var selectedFigure: Figure = .queen
    private var state: GameState

    init(state: GameState, useCase: GameUseCase, validation: GameValidationUseCase) {
        self.state = state
        self.size = state.size
        self.figures = Dictionary(uniqueKeysWithValues: state.placedFigures.map { ($0.position, $0.figure) })
        self.useCase = useCase
        self.validation = validation
    }
    
    func selectFigure(at position: Position) {
        selectedPosition = position
        if let newState = useCase.selectOn(position: position, state: state) {
            unpack(newState)
        }
    }
    
    func makeMoveTo(position: Position) {
        if let from = selectedPosition, let figure = figures[from] {
            unpack(useCase.move(figure: figure, from: from, to: position, state: state))
        } else {
            if !validation.isValid(figure: selectedFigure, position: position, game: state) {
                invalidPosition = position
            } else {
                invalidPosition = nil
            }
            unpack(useCase.set(figure: selectedFigure, on: position, state: state))
        }
    }
    
    func reset() {
        unpack(useCase.reset(state: state))
    }
    
    func isInvalidPosition(row: Int, column: Int) -> Bool {
        if let invalidPosition = invalidPosition, invalidPosition.row == row, invalidPosition.column == column {
            return true
        }
        return false
    }
    
    private func unpack(_ state: GameState) {
        self.state = state
        figures = Dictionary(uniqueKeysWithValues: state.placedFigures.map { ($0.position, $0.figure) })
        
        if let selectedPosition = selectedPosition {
            if nil == figures[selectedPosition] {
                self.selectedPosition = nil
            }
        }
        
        if let invalidPosition = invalidPosition, nil == figures[invalidPosition] {
            self.invalidPosition = nil
        }
    }
}
