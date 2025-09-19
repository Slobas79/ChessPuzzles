//
//  NQueensValidationUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

protocol NQueensValidationUseCase {
    func isValid(size: Int) -> Bool
    var minimumSize: Int { get }
}
