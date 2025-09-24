//
//  SettingsUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 23. 9. 2025..
//

protocol SettingsUseCase {
    var ColorScheme: ColorScheme { get set }
}

final class SettingsUseCaseImpl: SettingsUseCase {
    private var localRepo: LocalRepo
    
    var ColorScheme: ColorScheme {
        get {
            localRepo.colorScheme
        }
        set {
            localRepo.colorScheme = newValue
        }
    }
    
    init(localRepo: LocalRepo) {
        self.localRepo = localRepo
    }
}
