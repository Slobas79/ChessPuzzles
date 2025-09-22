//
//  DependencyInjectionContainer.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

final class DependencyInjectionContainer {
    // Repo
    private lazy var networkingRepo: NetworkingRepo = NetworkingRepoImpl()
    private lazy var discRepo: DiscRepo = DiscRepoImpl()
    
    // Use cases
    private(set) lazy var nqValidatorUseCase: NQueensValidationUseCase = NQueensValidationUseCaseImpl()
    private(set) lazy var nqRepoUseCase: NQueensRepoUseCase = NQueensRepoUseCaseImpl()
    
}
