//
//  NQueensGameViewModel.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 20. 9. 2025..
//

import Foundation

@Observable
class NQueensGameViewModel {
    enum ScreenState {
        case newGame(Int) // (minimum size)
        case gameInProgress
    }
    
    private let validationUC: NQueensValidationUseCase
    private(set) var boardViewModel: ChessBoardViewModel?
    private(set) var screenState: ScreenState
    
    init(validationUseCase: NQueensValidationUseCase, state: GameState?) {
        self.validationUC = validationUseCase
        
        if let state = state {
            self.boardViewModel = .init(size: state.size, positions: state.placedFigures)
            screenState = .gameInProgress
            return
        }
        screenState = .newGame(validationUseCase.minimumSize)
    }
    
    func startNewGame(size: Int) throws {
        guard validationUC.isValid(size: size) else {
            throw NQueensGameError.invalidSize
        }
        boardViewModel = .init(size: size, positions: [])
        screenState = .gameInProgress
    }
}

enum NQueensGameError: Error, LocalizedError {
    case invalidSize
    
    var errorDescription: String? {
        switch self {
        case .invalidSize:
            return "Size must be greater than or equal to 4."
        }
    }
}
