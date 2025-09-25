//
//  NQueensGameViewModelTests.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 25. 9. 2025..
//

import Testing
@testable import ChessPuzzles

@MainActor
struct NQueensGameViewModelTests {
    //MARK: mock
    final class MockNQueensValidationUseCase: NQueensValidationUseCase {
        let minimumSize = 4
        var isValidSizeCalled = false
        var shouldReturnValidSize = true
        var isValidPositionCalled = false
        var shouldReturnValidPosition = true
        
        func isValid(size: Int) -> Bool {
            isValidSizeCalled = true
            return shouldReturnValidSize && size >= minimumSize
        }
        
        func isValid(figure: Figure, position: Position, game: GameState) -> Bool {
            isValidPositionCalled = true
            return shouldReturnValidPosition
        }
    }
    
    final class MockNQueensGameUseCase: NQueensGameUseCase {
        var startCalled = false
        var mockGameState: GameState?
        
        override func start(size: Int, name: String?) -> GameState {
            startCalled = true
            return mockGameState ?? GameState(size: size, placedFigures: [],
                                              name: name ?? "\(size)-Queens",
                                              remainingFigures: [.queen: size],
                                              canReset: false, isSolved: false, time: 0.0)
        }
        
        override func reset(state: GameState) -> GameState {
            return GameState(size: state.size, placedFigures: [], name: state.name,
                             remainingFigures: [.queen: state.size], canReset: false,
                             isSolved: false, time: 0.0)
        }
        
        override func selectOn(position: Position, state: GameState) -> GameState? {
            return state
        }
        
        override func set(figure: Figure?, on position: Position, state: GameState) -> GameState {
            return state
        }
        
        override func move(figure: Figure, from: Position, to: Position, state: GameState) -> GameState {
            return state
        }
        
        override func remove(from: Position, state: GameState) -> GameState {
            return state
        }
        
        override func updateTimer(state: GameState, time: Double) -> GameState {
            return GameState(size: state.size, placedFigures: state.placedFigures,
                             name: state.name, remainingFigures: state.remainingFigures,
                             canReset: state.canReset, isSolved: state.isSolved,
                             time: state.time + time)
        }
    }
    
    final class MockSettingsUseCase: SettingsUseCase {
        var colorScheme: ColorScheme = .classic
        var colorSchemeGetCount = 0
        var colorSchemeSetCount = 0
        
        var colorSchemeGetter: ColorScheme {
            get {
                colorSchemeGetCount += 1
                return colorScheme
            }
            set {
                colorSchemeSetCount += 1
                colorScheme = newValue
            }
        }
    }
    
    final class MockScoreUseCase: ScoreUseCase {
        var bestTime: Double = 75.0
        var setBestTimeCalled = false
        var lastSetTime: Double?
        
        func setBestTime(_ time: Double) {
            setBestTimeCalled = true
            lastSetTime = time
            if time > 0 && time < bestTime {
                bestTime = time
            }
        }
    }
    
    //MARK: init
    @Test("Initialize with existing game state creates game in progress")
    func initializeWithExistingGameStateCreatesGameInProgress() {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        let mockScore = MockScoreUseCase()
        
        let existingState = GameState(size: 8, placedFigures: [], name: "Test Game",
                                      remainingFigures: [.queen: 8], canReset: false,
                                      isSolved: false, time: 15.5)
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: existingState)
        
        switch viewModel.screenState {
        case .gameInProgress:
            #expect(true) // Expected state
        case .newGame:
            #expect(Bool(false), "Should be in gameInProgress state")
        }
        
        #expect(viewModel.boardViewModel != nil)
        #expect(viewModel.boardViewModel?.size == 8)
    }
    
    @Test("Initialize with nil state creates new game state")
    func initializeWithNilStateCreatesNewGameState() {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        let mockScore = MockScoreUseCase()
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: nil)
        
        switch viewModel.screenState {
        case .newGame(let size):
            #expect(size == 4) // Should use minimumSize
        case .gameInProgress:
            #expect(Bool(false), "Should be in newGame state")
        }
        
        #expect(viewModel.boardViewModel == nil)
    }
    
    //MARK: screen state
    @Test("ScreenState enum cases work correctly")
    func screenStateEnumCasesWorkCorrectly() {
        let newGameState = NQueensGameViewModel.ScreenState.newGame(6)
        let gameInProgressState = NQueensGameViewModel.ScreenState.gameInProgress
        
        switch newGameState {
        case .newGame(let size):
            #expect(size == 6)
        case .gameInProgress:
            #expect(Bool(false), "Should be newGame case")
        }
        
        switch gameInProgressState {
        case .gameInProgress:
            #expect(true) // Expected
        case .newGame:
            #expect(Bool(false), "Should be gameInProgress case")
        }
    }
    
    //MARK: startNewGame
    @Test("startNewGame with valid size creates board and changes state")
    func startNewGameWithValidSizeCreatesBoardAndChangesState() throws {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        let mockScore = MockScoreUseCase()
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: nil)
        
        try viewModel.startNewGame(size: 8)
        
        #expect(mockValidation.isValidSizeCalled == true)
        #expect(mockGameUseCase.startCalled == true)
        #expect(viewModel.boardViewModel != nil)
        #expect(viewModel.boardViewModel?.size == 8)
        
        switch viewModel.screenState {
        case .gameInProgress:
            #expect(true) // Expected
        case .newGame:
            #expect(Bool(false), "Should be in gameInProgress state")
        }
    }
    
    @Test("startNewGame with invalid size throws error")
    func startNewGameWithInvalidSizeThrowsError() {
        let mockValidation = MockNQueensValidationUseCase()
        mockValidation.shouldReturnValidSize = false
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        let mockScore = MockScoreUseCase()
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: nil)
        
        #expect(throws: NQueensGameError.invalidSize) {
            try viewModel.startNewGame(size: 2)
        }
        
        #expect(viewModel.boardViewModel == nil)
        
        switch viewModel.screenState {
        case .newGame:
            #expect(true) // Should remain in newGame state
        case .gameInProgress:
            #expect(Bool(false), "Should remain in newGame state")
        }
    }
    
    @Test("startNewGame uses settings color scheme")
    func startNewGameUsesSettingsColorScheme() throws {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        mockSettings.colorScheme = .brown
        let mockScore = MockScoreUseCase()
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: nil)
        
        try viewModel.startNewGame(size: 6)
        
        #expect(viewModel.boardViewModel?.colorScheme == .brown)
    }
    
    // MARK: canReset
    @Test("canReset returns false when no board view model")
    func canResetReturnsFalseWhenNoBoardViewModel() {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        let mockScore = MockScoreUseCase()
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: nil)
        
        #expect(viewModel.canReset == false)
    }
    
    @Test("canReset reflects board view model state")
    func canResetReflectsBoardViewModelState() {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        let mockScore = MockScoreUseCase()
        
        // Create state with canReset = true, isSolved = false
        let gameState = GameState(size: 4, placedFigures: [
            FigurePosition(position: Position(row: 0, column: 0), figure: .queen)
        ], name: "Test", remainingFigures: [.queen: 3], canReset: true,
                                  isSolved: false, time: 0.0)
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: gameState)
        
        #expect(viewModel.canReset == true)
    }
    
    @Test("canReset returns false when game is solved")
    func canResetReturnsFalseWhenGameIsSolved() {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        let mockScore = MockScoreUseCase()
        
        // Create solved game state
        let gameState = GameState(size: 4, placedFigures: [
            FigurePosition(position: Position(row: 0, column: 0), figure: .queen)
        ], name: "Test", remainingFigures: [.queen: 3], canReset: true,
                                  isSolved: true, time: 45.0)
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: gameState)
        
        #expect(viewModel.canReset == false) // Should be false because isSolved = true
    }
    
    // MARK: updateSettings
    @Test("updateSettings updates board view model color scheme")
    func updateSettingsUpdatesBoardViewModelColorScheme() throws {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        mockSettings.colorScheme = .classic
        let mockScore = MockScoreUseCase()
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: nil)
        
        try viewModel.startNewGame(size: 4)
        #expect(viewModel.boardViewModel?.colorScheme == .classic)
        
        // Change settings
        mockSettings.colorScheme = .brown
        viewModel.updateSettings()
        
        #expect(viewModel.boardViewModel?.colorScheme == .brown)
    }
    
    @Test("updateSettings does nothing when no board view model")
    func updateSettingsDoesNothingWhenNoBoardViewModel() {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        let mockScore = MockScoreUseCase()
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: nil)
        
        // Should not crash when called without board view model
        viewModel.updateSettings()
        
        #expect(viewModel.boardViewModel == nil)
    }
    
    // MARK: saveTime
    @Test("saveTime calls board view model and score use case")
    func saveTimeCallsBoardViewModelAndScoreUseCase() {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        let mockScore = MockScoreUseCase()
        
        let gameState = GameState(size: 4, placedFigures: [], name: "Test",
                                  remainingFigures: [.queen: 4], canReset: false,
                                  isSolved: true, time: 42.5)
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: gameState)
        
        viewModel.saveTime()
        
        #expect(mockScore.setBestTimeCalled == true)
        #expect(mockScore.lastSetTime == 42.5)
    }
    
    @Test("saveTime does nothing when no board view model")
    func saveTimeDoesNothingWhenNoBoardViewModel() {
        let mockValidation = MockNQueensValidationUseCase()
        let mockGameUseCase = MockNQueensGameUseCase()
        let mockSettings = MockSettingsUseCase()
        let mockScore = MockScoreUseCase()
        
        let viewModel = NQueensGameViewModel(validationUseCase: mockValidation,
                                             nQueensUseCase: mockGameUseCase,
                                             settingsUseCase: mockSettings,
                                             scoreUseCase: mockScore,
                                             state: nil)
        
        viewModel.saveTime()
        
        #expect(mockScore.setBestTimeCalled == false)
    }
    
    //MARK: error
    @Test("NQueensGameError invalidSize has correct description")
    func nQueensGameErrorInvalidSizeHasCorrectDescription() {
        let error = NQueensGameError.invalidSize
        #expect(error.errorDescription == "Size must be greater than or equal to 4.")
    }
}
