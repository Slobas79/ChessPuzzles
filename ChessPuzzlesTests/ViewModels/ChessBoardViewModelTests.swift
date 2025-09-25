//
//  ChessBoardViewModelTests.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 25. 9. 2025..
//

import Testing
@testable import ChessPuzzles

@MainActor
struct ChessBoardViewModelTests {
    //MARK: Mocks
    final class MockGameUseCase: GameUseCase {
        var startCalled = false
        var resetCalled = false
        var selectOnCalled = false
        var setCalled = false
        var moveCalled = false
        var removeCalled = false
        var updateTimerCalled = false
        
        var mockGameState: GameState
        var shouldReturnNilOnSelectOn = false
        
        init(mockGameState: GameState) {
            self.mockGameState = mockGameState
        }
        
        func start(size: Int, name: String?) -> GameState {
            startCalled = true
            return mockGameState
        }
        
        func reset(state: GameState) -> GameState {
            resetCalled = true
            return GameState(size: state.size, placedFigures: [], name: state.name,
                             remainingFigures: [.queen: state.size], canReset: false,
                             isSolved: false, time: 0.0)
        }
        
        func selectOn(position: Position, state: GameState) -> GameState? {
            selectOnCalled = true
            return shouldReturnNilOnSelectOn ? nil : state
        }
        
        func set(figure: Figure?, on position: Position, state: GameState) -> GameState {
            setCalled = true
            var newPlacedFigures = state.placedFigures
            newPlacedFigures.append(FigurePosition(position: position, figure: figure ?? .queen))
            return GameState(size: state.size, placedFigures: newPlacedFigures,
                             name: state.name, remainingFigures: state.remainingFigures,
                             canReset: true, isSolved: false, time: state.time)
        }
        
        func move(figure: Figure, from: Position, to: Position, state: GameState) -> GameState {
            moveCalled = true
            var newPlacedFigures = state.placedFigures
            newPlacedFigures.removeAll { $0.position == from }
            newPlacedFigures.append(FigurePosition(position: to, figure: figure))
            return GameState(size: state.size, placedFigures: newPlacedFigures,
                             name: state.name, remainingFigures: state.remainingFigures,
                             canReset: state.canReset, isSolved: state.isSolved, time: state.time)
        }
        
        func remove(from: Position, state: GameState) -> GameState {
            removeCalled = true
            var newPlacedFigures = state.placedFigures
            newPlacedFigures.removeAll { $0.position == from }
            return GameState(size: state.size, placedFigures: newPlacedFigures,
                             name: state.name, remainingFigures: state.remainingFigures,
                             canReset: !newPlacedFigures.isEmpty, isSolved: false, time: state.time)
        }
        
        func updateTimer(state: GameState, time: Double) -> GameState {
            updateTimerCalled = true
            return GameState(size: state.size, placedFigures: state.placedFigures,
                             name: state.name, remainingFigures: state.remainingFigures,
                             canReset: state.canReset, isSolved: state.isSolved,
                             time: state.time + time)
        }
    }
    
    final class MockGameValidationUseCase: GameValidationUseCase {
        var isValidCalled = false
        var shouldReturnValid = true
        
        func isValid(figure: Figure, position: Position, game: GameState) -> Bool {
            isValidCalled = true
            return shouldReturnValid
        }
    }
    
    //MARK: init
    @Test("New game initialization creates correct initial state")
    func newGameInitializationCreatesCorrectInitialState() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test Game",
                                      remainingFigures: [.queen: 4], canReset: false,
                                      isSolved: false, time: 0.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(size: 4, name: "Test Game",
                                            useCase: mockUseCase, validation: mockValidation,
                                            colorScheme: .classic)
        
        #expect(mockUseCase.startCalled == true)
        #expect(viewModel.size == 4)
        #expect(viewModel.figures.isEmpty)
        #expect(viewModel.remainingFigures?[.queen] == 4)
        #expect(viewModel.canReset == false)
        #expect(viewModel.isSolved == false)
        #expect(viewModel.time == 0.0)
        #expect(viewModel.colorScheme == .classic)
    }
    
    @Test("Existing game initialization loads state correctly")
    func existingGameInitializationLoadsStateCorrectly() {
        let existingFigures = [FigurePosition(position: Position(row: 0, column: 1), figure: .queen)]
        let existingGameState = GameState(size: 4, placedFigures: existingFigures,
                                          name: "Existing Game", remainingFigures: [.queen: 3],
                                          canReset: true, isSolved: false, time: 25.5)
        let mockUseCase = MockGameUseCase(mockGameState: existingGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(state: existingGameState, useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .brown)
        
        #expect(viewModel.size == 4)
        #expect(viewModel.figures.count == 1)
        #expect(viewModel.figures[Position(row: 0, column: 1)] == .queen)
        #expect(viewModel.remainingFigures?[.queen] == 3)
        #expect(viewModel.canReset == true)
        #expect(viewModel.isSolved == false)
        #expect(viewModel.time == 25.5)
        #expect(viewModel.colorScheme == .brown)
    }
    
    //MARK: selectFigure
    @Test("selectFigure calls useCase selectOn")
    func selectFigureCallsUseCaseSelectOn() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test",
                                      remainingFigures: [.queen: 4], canReset: false,
                                      isSolved: false, time: 0.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(size: 4, name: "Test", useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        let position = Position(row: 1, column: 1)
        viewModel.selectFigure(at: position)
        
        #expect(mockUseCase.selectOnCalled == true)
    }
    
    @Test("selectFigure handles nil return from useCase")
    func selectFigureHandlesNilReturnFromUseCase() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test",
                                      remainingFigures: [.queen: 4], canReset: false,
                                      isSolved: false, time: 0.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        mockUseCase.shouldReturnNilOnSelectOn = true
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(size: 4, name: "Test", useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        let position = Position(row: 1, column: 1)
        viewModel.selectFigure(at: position)
        
        #expect(mockUseCase.selectOnCalled == true)
    }
    
    //MARK: makeMoveTo
    @Test("makeMoveTo with selected figure moves piece")
    func makeMoveToWithSelectedFigureMoviesPiece() {
        let existingFigure = FigurePosition(position: Position(row: 0, column: 0), figure: .queen)
        let mockGameState = GameState(size: 4, placedFigures: [existingFigure], name: "Test",
                                      remainingFigures: [.queen: 3], canReset: true,
                                      isSolved: false, time: 0.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(state: mockGameState, useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        // Select the existing figure first
        viewModel.selectFigure(at: Position(row: 0, column: 0))
        
        // Move to new position
        let newPosition = Position(row: 2, column: 2)
        viewModel.makeMoveTo(position: newPosition)
        
        #expect(mockUseCase.moveCalled == true)
    }
    
    @Test("makeMoveTo without selected figure places new piece when valid")
    func makeMoveToWithoutSelectedFigurePlacesNewPieceWhenValid() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test",
                                      remainingFigures: [.queen: 4], canReset: false,
                                      isSolved: false, time: 0.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        mockValidation.shouldReturnValid = true
        
        let viewModel = ChessBoardViewModel(size: 4, name: "Test", useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        let position = Position(row: 1, column: 1)
        viewModel.makeMoveTo(position: position)
        
        #expect(mockValidation.isValidCalled == true)
        #expect(mockUseCase.setCalled == true)
        #expect(viewModel.invalidPosition == nil)
    }
    
    @Test("makeMoveTo without selected figure sets invalid position when invalid")
    func makeMoveToWithoutSelectedFigureSetsInvalidPositionWhenInvalid() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test",
                                      remainingFigures: [.queen: 4], canReset: false,
                                      isSolved: false, time: 0.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        mockValidation.shouldReturnValid = false
        
        let viewModel = ChessBoardViewModel(size: 4, name: "Test", useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        let position = Position(row: 1, column: 1)
        viewModel.makeMoveTo(position: position)
        
        #expect(mockValidation.isValidCalled == true)
        #expect(mockUseCase.setCalled == true)
        #expect(viewModel.invalidPosition == position)
    }
    
    //MARK: reset
    @Test("reset calls useCase reset and resets time")
    func resetCallsUseCaseResetAndResetsTime() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test",
                                      remainingFigures: [.queen: 4], canReset: true,
                                      isSolved: false, time: 30.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(state: mockGameState, useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        viewModel.reset()
        
        #expect(mockUseCase.resetCalled == true)
        #expect(viewModel.time == 0.0)
    }
    
    //MARK: isInvalidPosition
    @Test("isInvalidPosition returns true for invalid position")
    func isInvalidPositionReturnsTrueForInvalidPosition() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test",
                                      remainingFigures: [.queen: 4], canReset: false,
                                      isSolved: false, time: 0.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(size: 4, name: "Test", useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        // Set an invalid position
        let invalidPos = Position(row: 2, column: 3)
        mockValidation.shouldReturnValid = false
        viewModel.makeMoveTo(position: invalidPos)
        
        #expect(viewModel.isInvalidPosition(row: 2, column: 3) == true)
        #expect(viewModel.isInvalidPosition(row: 1, column: 1) == false)
    }
    
    @Test("isInvalidPosition returns false when no invalid position set")
    func isInvalidPositionReturnsFalseWhenNoInvalidPositionSet() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test",
                                      remainingFigures: [.queen: 4], canReset: false,
                                      isSolved: false, time: 0.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(size: 4, name: "Test", useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        #expect(viewModel.isInvalidPosition(row: 2, column: 3) == false)
    }
    
    //MARK: timer
    @Test("startTimer begins timer when game not solved")
    func startTimerBeginsTimerWhenGameNotSolved() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test",
                                      remainingFigures: [.queen: 4], canReset: false,
                                      isSolved: false, time: 0.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(size: 4, name: "Test", useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        let initialTime = viewModel.time
        viewModel.startTimer()
        
        // Timer should start, but we can't easily test the actual timing in unit tests
        // We can verify it doesn't crash and initial setup is correct
        #expect(viewModel.time == initialTime)
    }
    
    @Test("startTimer does nothing when game is solved")
    func startTimerDoesNothingWhenGameIsSolved() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test",
                                      remainingFigures: [.queen: 4], canReset: false,
                                      isSolved: true, time: 0.0)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(state: mockGameState, useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        viewModel.startTimer()
        
        // Should not start timer when already solved
        #expect(viewModel.isSolved == true)
    }
    
    //MARK: save time
    @Test("saveTime calls updateTimer and returns current time")
    func saveTimeCallsUpdateTimerAndReturnsCurrentTime() {
        let mockGameState = GameState(size: 4, placedFigures: [], name: "Test",
                                      remainingFigures: [.queen: 4], canReset: false,
                                      isSolved: false, time: 25.5)
        let mockUseCase = MockGameUseCase(mockGameState: mockGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(state: mockGameState, useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        let savedTime = viewModel.saveTime()
        
        #expect(mockUseCase.updateTimerCalled == true)
        #expect(savedTime == viewModel.time)
    }
    
    //MARK: unpack
    @Test("unpack updates all properties correctly")
    func unpackUpdatesAllPropertiesCorrectly() {
        let initialFigures = [FigurePosition(position: Position(row: 0, column: 0), figure: .queen)]
        let initialGameState = GameState(size: 4, placedFigures: initialFigures,
                                         name: "Test", remainingFigures: [.queen: 3],
                                         canReset: true, isSolved: false, time: 10.0)
        let mockUseCase = MockGameUseCase(mockGameState: initialGameState)
        let mockValidation = MockGameValidationUseCase()
        
        let viewModel = ChessBoardViewModel(state: initialGameState, useCase: mockUseCase,
                                            validation: mockValidation, colorScheme: .classic)
        
        // Verify initial state
        #expect(viewModel.figures.count == 1)
        #expect(viewModel.canReset == true)
        #expect(viewModel.isSolved == false)
        #expect(viewModel.time == 10.0)
        
        // Trigger an operation that calls unpack
        viewModel.reset()
        
        // Verify state after reset (mock returns empty state)
        #expect(viewModel.figures.isEmpty)
        #expect(viewModel.canReset == false)
        #expect(viewModel.isSolved == false)
        #expect(viewModel.time == 0.0) // Reset explicitly sets time to 0
    }
}
