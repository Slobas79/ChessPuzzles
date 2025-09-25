//
//  NQueensGameUseCaseTests.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 24. 9. 2025..
//

import Testing
@testable import ChessPuzzles

struct NQueensGameUseCaseTests {
    private let useCase = NQueensGameUseCase()
    
    //MARK: Start
    @Test("Start game creates initial state with correct size")
    func startGameCreatesInitialState() {
        let state = useCase.start(size: 8, name: "Test Game")
        
        #expect(state.size == 8)
        #expect(state.name == "Test Game")
        #expect(state.placedFigures.isEmpty)
        #expect(state.remainingFigures?[.queen] == 8)
        #expect(state.canReset == false)
        #expect(state.isSolved == false)
        #expect(state.time == 0.0)
    }
    
    //MARK: Reset
    @Test("Reset returns to initial state")
    func resetReturnsToInitialState() {
        let initialState = useCase.start(size: 4, name: "Test")
        let position = Position(row: 0, column: 0)
        let modifiedState = useCase.set(figure: .queen, on: position, state: initialState)
        
        let resetState = useCase.reset(state: modifiedState)
        
        #expect(resetState.size == modifiedState.size)
        #expect(resetState.name == modifiedState.name)
        #expect(resetState.placedFigures.isEmpty)
        #expect(resetState.remainingFigures?[.queen] == resetState.size)
        #expect(resetState.canReset == false)
        #expect(resetState.isSolved == false)
        #expect(resetState.time == 0.0)
    }
    
    //MARK: Set
    @Test("Set figure places queen on board")
    func setFigurePlacesQueen() {
        let initialState = useCase.start(size: 4, name: "Test")
        let position = Position(row: 1, column: 2)
        
        let newState = useCase.set(figure: .queen, on: position, state: initialState)
        
        #expect(newState.placedFigures.count == 1)
        #expect(newState.placedFigures.first?.position == position)
        #expect(newState.placedFigures.first?.figure == .queen)
        #expect(newState.remainingFigures?[.queen] == 3)
        #expect(newState.canReset == true)
        #expect(newState.isSolved == false)
    }
    
    @Test("Set figure with nil defaults to queen")
    func setFigureWithNilDefaultsToQueen() {
        let initialState = useCase.start(size: 4, name: "Test")
        let position = Position(row: 0, column: 0)
        
        let newState = useCase.set(figure: nil, on: position, state: initialState)
        
        #expect(newState.placedFigures.first?.figure == .queen)
    }
    
    @Test("Set figure when board is full returns unchanged state")
    func setFigureWhenBoardFullReturnsUnchangedState() {
        var state = useCase.start(size: 4, name: "Test")
        
        // Fill the board
        state = useCase.set(figure: .queen, on: Position(row: 0, column: 1), state: state)
        state = useCase.set(figure: .queen, on: Position(row: 1, column: 3), state: state)
        state = useCase.set(figure: .queen, on: Position(row: 2, column: 0), state: state)
        state = useCase.set(figure: .queen, on: Position(row: 3, column: 2), state: state)
        
        let fullState = state
        let attemptedState = useCase.set(figure: .queen, on: Position(row: 0, column: 1), state:
                                            fullState)
        
        #expect(attemptedState == fullState)
    }
    
    @Test("Set figure marks game as solved when all queens placed")
    func setFigureMarksSolvedWhenAllQueensPlaced() {
        var state = useCase.start(size: 4, name: "Test")
        
        state = useCase.set(figure: .queen, on: Position(row: 0, column: 1), state: state)
        state = useCase.set(figure: .queen, on: Position(row: 1, column: 3), state: state)
        state = useCase.set(figure: .queen, on: Position(row: 2, column: 0), state: state)
        #expect(state.isSolved == false)
        
        state = useCase.set(figure: .queen, on: Position(row: 3, column: 2), state: state)
        #expect(state.isSolved == true)
    }
    
    //MARK: Move
    @Test("Move figure updates position")
    func moveFigureUpdatesPosition() {
        var state = useCase.start(size: 4, name: "Test")
        let fromPosition = Position(row: 0, column: 0)
        let toPosition = Position(row: 1, column: 1)
        
        state = useCase.set(figure: .queen, on: fromPosition, state: state)
        let movedState = useCase.move(figure: .queen, from: fromPosition, to: toPosition, state:
                                        state)
        
        #expect(movedState.placedFigures.count == 1)
        #expect(movedState.placedFigures.first?.position == toPosition)
        #expect(movedState.placedFigures.first?.figure == .queen)
    }
    
    @Test("Move figure maintains remaining count")
    func moveFigureMaintainsRemainingCount() {
        var state = useCase.start(size: 4, name: "Test")
        let fromPosition = Position(row: 0, column: 0)
        let toPosition = Position(row: 1, column: 1)
        
        state = useCase.set(figure: .queen, on: fromPosition, state: state)
        let movedState = useCase.move(figure: .queen, from: fromPosition, to: toPosition, state:
                                        state)
        
        #expect(movedState.remainingFigures?[.queen] == 3)
    }
    
    //MARK: Remove
    @Test("Remove figure removes from board")
    func removeFigureRemovesFromBoard() {
        var state = useCase.start(size: 4, name: "Test")
        let position = Position(row: 0, column: 0)
        
        state = useCase.set(figure: .queen, on: position, state: state)
        let removedState = useCase.remove(from: position, state: state)
        
        #expect(removedState.placedFigures.isEmpty)
        #expect(removedState.remainingFigures?[.queen] == 4)
        #expect(removedState.canReset == false)
    }
    
    @Test("Remove nonexistent figure returns unchanged state")
    func removeNonexistentFigureReturnsUnchangedState() {
        let state = useCase.start(size: 4, name: "Test")
        let position = Position(row: 0, column: 0)
        
        let removedState = useCase.remove(from: position, state: state)
        
        #expect(removedState == state)
    }
    
    //MARK: Select
    @Test("SelectOn delegates to remove")
    func selectOnDelegatesToRemove() {
        var state = useCase.start(size: 4, name: "Test")
        let position = Position(row: 0, column: 0)
        
        state = useCase.set(figure: .queen, on: position, state: state)
        let selectedState = useCase.selectOn(position: position, state: state)
        let removedState = useCase.remove(from: position, state: state)
        
        #expect(selectedState == removedState)
    }
    
    //MARK: updateTimer
    @Test("UpdateTimer adds time to existing time")
    func updateTimerAddsTimeToExistingTime() {
        var state = useCase.start(size: 4, name: "Test")
        state = useCase.updateTimer(state: state, time: 5.5)
        
        #expect(state.time == 5.5)
        
        state = useCase.updateTimer(state: state, time: 2.3)
        
        #expect(state.time == 7.8)
    }
    
    @Test("UpdateTimer preserves other state properties")
    func updateTimerPreservesOtherProperties() {
        var state = useCase.start(size: 4, name: "Test")
        state = useCase.set(figure: .queen, on: Position(row: 0, column: 0), state: state)
        
        let originalPlacedCount = state.placedFigures.count
        let originalCanReset = state.canReset
        
        let timedState = useCase.updateTimer(state: state, time: 10.0)
        
        #expect(timedState.placedFigures.count == originalPlacedCount)
        #expect(timedState.canReset == originalCanReset)
        #expect(timedState.size == state.size)
        #expect(timedState.name == state.name)
    }
    
}
