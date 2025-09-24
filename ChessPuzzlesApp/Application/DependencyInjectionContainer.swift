//
//  DependencyInjectionContainer.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

final class DependencyInjectionContainer {
    // Repo
    private lazy var localRepo: LocalRepo = LocalRepoImpl()
    
    // Use cases
    private(set) lazy var nqValidatorUseCase: NQueensValidationUseCase = NQueensValidationUseCaseImpl()
    private(set) lazy var nQueensGameUseCase: NQueensGameUseCase = NQueensGameUseCase()
    private(set) lazy var nqRepoUseCase: NQueensRepoUseCase = NQueensRepoUseCaseMock()
    private(set) lazy var settingsUseCase: SettingsUseCase = SettingsUseCaseImpl(localRepo: localRepo)
    private(set) lazy var scoreUseCase: ScoreUseCase = ScoreUseCaseImpl(localRepo: localRepo)
}
