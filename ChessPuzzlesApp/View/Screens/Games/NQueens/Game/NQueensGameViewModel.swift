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
    private let scoreUC: ScoreUseCase
    private(set) var boardViewModel: ChessBoardViewModel?
    private(set) var screenState: ScreenState
    
    var canReset: Bool {
        guard let boardVM = boardViewModel else { return false }
        return boardVM.canReset && !boardVM.isSolved
    }
    
    init(validationUseCase: NQueensValidationUseCase,
         nQueensUseCase: NQueensGameUseCase,
         settingsUseCase: SettingsUseCase,
         scoreUseCase: ScoreUseCase,
         state: GameState?) {
        self.validationUC = validationUseCase
        self.nQueensUC = nQueensUseCase
        self.settingsUC = settingsUseCase
        self.scoreUC = scoreUseCase
        
        if let state = state {
            boardViewModel = .init(state: state,
                                   useCase: nQueensUC,
                                   validation: validationUC,
                                   colorScheme: settingsUC.colorScheme)
            screenState = .gameInProgress
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
    }
    
    func updateSettings() {
        boardViewModel?.colorScheme = settingsUC.colorScheme
    }
    
    func saveTime() {
        if let boardVM = boardViewModel {
            let time = boardVM.saveTime()
            scoreUC.setBestTime(time)
        }
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
