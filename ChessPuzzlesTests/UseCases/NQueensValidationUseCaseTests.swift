//
//  NQueensValidationUseCaseTests.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 25. 9. 2025..
//

import Testing
@testable import ChessPuzzles


struct NQueensValidationUseCaseTests {
    private let validationUseCase = NQueensValidationUseCaseImpl()
    
    //MARK: minimum size
    @Test("Minimum size is 4")
    func minimumSizeIs4() {
        #expect(validationUseCase.minimumSize == 4)
    }
    
    //MARK: minimum size
    @Test("Valid sizes return true")
    func validSizesReturnTrue() async {
        let validSizes = [4, 5, 6, 8, 10, 12, 16]
        
        for size in validSizes {
            #expect(validationUseCase.isValid(size: size) == true)
        }
    }
    
    @Test("Invalid sizes return false")
    func invalidSizesReturnFalse() async {
        let invalidSizes = [0, 1, 2, 3, -1, -5]
        
        for size in invalidSizes {
            #expect(validationUseCase.isValid(size: size) == false)
        }
    }
    
    //MARK: valid position
    @Test("Valid position on empty board returns true")
    func validPositionOnEmptyBoardReturnsTrue() {
        let gameState = GameState(
            size: 4,
            placedFigures: [],
            name: "Test",
            remainingFigures: [.queen: 4],
            canReset: false,
            isSolved: false,
            time: 0.0
        )
        let position = Position(row: 1, column: 1)
        
        let result = validationUseCase.isValid(figure: .queen, position: position, game: gameState)
        
        #expect(result == true)
    }
    
    @Test("Position out of bounds returns false")
    func positionOutOfBoundsReturnsFalse() {
        let gameState = GameState(
            size: 4,
            placedFigures: [],
            name: "Test",
            remainingFigures: [.queen: 4],
            canReset: false,
            isSolved: false,
            time: 0.0
        )
        
        let outOfBoundsPositions = [
            Position(row: -1, column: 0),    // Negative row
            Position(row: 0, column: -1),    // Negative column
            Position(row: 4, column: 0),     // Row >= size
            Position(row: 0, column: 4),     // Column >= size
            Position(row: 5, column: 5),     // Both out of bounds
            Position(row: -2, column: -3)    // Both negative
        ]
        
        for position in outOfBoundsPositions {
            let result = validationUseCase.isValid(figure: .queen, position: position, game:
                                                    gameState)
            #expect(result == false, "Position \(position) should be invalid")
        }
    }
    
    @Test("Same row attack returns false")
    func sameRowAttackReturnsFalse() {
        let existingQueen = FigurePosition(position: Position(row: 1, column: 1), figure: .queen)
        let gameState = GameState(
            size: 4,
            placedFigures: [existingQueen],
            name: "Test",
            remainingFigures: [.queen: 3],
            canReset: true,
            isSolved: false,
            time: 0.0
        )
        
        let sameRowPositions = [
            Position(row: 1, column: 0),
            Position(row: 1, column: 2),
            Position(row: 1, column: 3)
        ]
        
        for position in sameRowPositions {
            let result = validationUseCase.isValid(figure: .queen, position: position, game:
                                                    gameState)
            #expect(result == false, "Position \(position) should be invalid (same row)")
        }
    }
    
    @Test("Same column attack returns false")
    func sameColumnAttackReturnsFalse() {
        let existingQueen = FigurePosition(position: Position(row: 1, column: 2), figure: .queen)
        let gameState = GameState(
            size: 4,
            placedFigures: [existingQueen],
            name: "Test",
            remainingFigures: [.queen: 3],
            canReset: true,
            isSolved: false,
            time: 0.0
        )
        
        let sameColumnPositions = [
            Position(row: 0, column: 2),
            Position(row: 2, column: 2),
            Position(row: 3, column: 2)
        ]
        
        for position in sameColumnPositions {
            let result = validationUseCase.isValid(figure: .queen, position: position, game:
                                                    gameState)
            #expect(result == false, "Position \(position) should be invalid (same column)")
        }
    }
    
    @Test("Main diagonal attack returns false")
    func mainDiagonalAttackReturnsFalse() {
        let existingQueen = FigurePosition(position: Position(row: 1, column: 1), figure: .queen)
        let gameState = GameState(
            size: 4,
            placedFigures: [existingQueen],
            name: "Test",
            remainingFigures: [.queen: 3],
            canReset: true,
            isSolved: false,
            time: 0.0
        )
        
        // Main diagonal: positions where row - column = 1 - 1 = 0
        let mainDiagonalPositions = [
            Position(row: 0, column: 0),  // 0 - 0 = 0
            Position(row: 2, column: 2),  // 2 - 2 = 0
            Position(row: 3, column: 3)   // 3 - 3 = 0
        ]
        
        for position in mainDiagonalPositions {
            let result = validationUseCase.isValid(figure: .queen, position: position, game:
                                                    gameState)
            #expect(result == false, "Position \(position) should be invalid (main diagonal)")
        }
    }
    
    @Test("Anti diagonal attack returns false")
    func antiDiagonalAttackReturnsFalse() {
        let existingQueen = FigurePosition(position: Position(row: 1, column: 2), figure: .queen)
        let gameState = GameState(
            size: 4,
            placedFigures: [existingQueen],
            name: "Test",
            remainingFigures: [.queen: 3],
            canReset: true,
            isSolved: false,
            time: 0.0
        )
        
        // Anti-diagonal: positions where row + column = 1 + 2 = 3
        let antiDiagonalPositions = [
            Position(row: 0, column: 3),  // 0 + 3 = 3
            Position(row: 2, column: 1),  // 2 + 1 = 3
            Position(row: 3, column: 0)   // 3 + 0 = 3
        ]
        
        for position in antiDiagonalPositions {
            let result = validationUseCase.isValid(figure: .queen, position: position, game:
                                                    gameState)
            #expect(result == false, "Position \(position) should be invalid (anti-diagonal)")
        }
    }
    
    @Test("Valid position not under attack returns true")
    func validPositionNotUnderAttackReturnsTrue() {
        let existingQueen = FigurePosition(position: Position(row: 0, column: 1), figure: .queen)
        let gameState = GameState(
            size: 4,
            placedFigures: [existingQueen],
            name: "Test",
            remainingFigures: [.queen: 3],
            canReset: true,
            isSolved: false,
            time: 0.0
        )
        
        // Position that doesn't conflict with queen at (0,1)
        let validPosition = Position(row: 2, column: 0)
        
        let result = validationUseCase.isValid(figure: .queen, position: validPosition, game:
                                                gameState)
        
        #expect(result == true)
    }
    
    @Test("Multiple queens complex scenario")
    func multipleQueensComplexScenario() {
        let existingQueens = [
            FigurePosition(position: Position(row: 0, column: 1), figure: .queen),
            FigurePosition(position: Position(row: 1, column: 3), figure: .queen),
            FigurePosition(position: Position(row: 2, column: 0), figure: .queen)
        ]
        
        let gameState = GameState(
            size: 4,
            placedFigures: existingQueens,
            name: "Test",
            remainingFigures: [.queen: 1],
            canReset: true,
            isSolved: false,
            time: 0.0
        )
        
        // Test various positions
        #expect(validationUseCase.isValid(figure: .queen, position: Position(row: 3, column: 2),
                                          game: gameState) == true)   // Valid position
        #expect(validationUseCase.isValid(figure: .queen, position: Position(row: 0, column: 0),
                                          game: gameState) == false)  // Same row as queen at (0,1)
        #expect(validationUseCase.isValid(figure: .queen, position: Position(row: 3, column: 3),
                                          game: gameState) == false)  // Same column as queen at (1,3)
        #expect(validationUseCase.isValid(figure: .queen, position: Position(row: 3, column: 1),
                                          game: gameState) == false)  // Same column as queen at (0,1)
    }
}
