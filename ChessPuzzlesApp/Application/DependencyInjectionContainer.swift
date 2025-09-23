//
//  DependencyInjectionContainer.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

final class DependencyInjectionContainer {
    // Repo
    private lazy var networkingRepo: NetworkingRepo = NetworkingRepoImpl()
    private lazy var localRepo: LocalRepo = LocalRepoImpl()
    
    // Use cases
    private(set) lazy var nqValidatorUseCase: NQueensValidationUseCase = NQueensValidationUseCaseImpl()
    private(set) lazy var nQueensGameUseCase: NQueensGameUseCase = NQueensGameUseCase()
    private(set) lazy var nqRepoUseCase: NQueensRepoUseCase = NQueensRepoUseCaseImpl()
    
}
