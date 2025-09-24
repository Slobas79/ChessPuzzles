//
//  NQueensGameViewModel.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 20. 9. 2025..
//

import Foundation
import Combine

@Observable
class NQueensGameViewModel {
    enum ScreenState {
        case newGame(Int) // (size)
        case gameInProgress
    }
    
    private let nQueensUC: NQueensGameUseCase
    private let validationUC: NQueensValidationUseCase
    private let settingsUC: SettingsUseCase
    private(set) var boardViewModel: ChessBoardViewModel?
    private(set) var screenState: ScreenState
    
    init(validationUseCase: NQueensValidationUseCase, nQueensUseCase: NQueensGameUseCase, settingsUseCase: SettingsUseCase, state: GameState?) {
        self.validationUC = validationUseCase
        self.nQueensUC = nQueensUseCase
        self.settingsUC = settingsUseCase
        
        if let state = state {
            boardViewModel = .init(state: state,
                                   useCase: nQueensUC,
                                   validation: validationUC,
                                   colorScheme: settingsUC.colorScheme)
            screenState = .gameInProgress
            boardViewModel?.startTimer()
            return
        }
        screenState = .newGame(validationUseCase.minimumSize)
    }
    
    func startNewGame(size: Int) throws {
        guard validationUC.isValid(size: size) else {
            throw NQueensGameError.invalidSize
        }
        boardViewModel = .init(size: size,
                               name: nil,
                               useCase: nQueensUC,
                               validation: validationUC,
                               colorScheme: settingsUC.colorScheme)
        screenState = .gameInProgress
        boardViewModel?.startTimer()
    }
    
    func resetGame() {
        boardViewModel?.reset()
    }
    
    func updateSettings() {
        boardViewModel?.colorScheme = settingsUC.colorScheme
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
