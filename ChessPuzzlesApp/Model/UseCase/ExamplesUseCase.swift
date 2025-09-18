//
//  ExamplesUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

protocol ExamplesUseCase {
    func getExamples() -> [Example]?
}

final class ExamplesUseCaseImpl: ExamplesUseCase {
    private let networkingRepo: NetworkingRepo
    
    init(networkingRepo: NetworkingRepo) {
        self.networkingRepo = networkingRepo
    }
    
    func getExamples() -> [Example]? {
        return nil
    }
}
