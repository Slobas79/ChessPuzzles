//
//  NQueensValidationUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

protocol NQueensValidationUseCase: GameValidationUseCase {
    func isValid(size: Int) -> Bool
    var minimumSize: Int { get }
}

final class NQueensValidationUseCaseImpl: NQueensValidationUseCase {
    let minimumSize = 4
    
    func isValid(size: Int) -> Bool {
        return size >= minimumSize
    }
    
    func isValid(figure: Figure, position: Position, game: GameState) -> Bool {
        let inBounds = position.row >= 0 && position.row < game.size &&
        position.column >= 0 && position.column < game.size
        guard inBounds else {
            return false
        }
        
        for queen in game.placedFigures {
            if queen.position.row == position.row ||
                queen.position.column == position.column ||
                queen.position.row - queen.position.column == position.row - position.column ||
                queen.position.row + queen.position.column == position.row + position.column {
                return false
            }
        }
        
        return true
    }
}
