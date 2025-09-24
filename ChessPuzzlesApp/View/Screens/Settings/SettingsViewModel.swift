//
//  SettingsViewModel.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 23. 9. 2025..
//

import SwiftUI

@Observable
final class SettingsViewModel {
    private var useCase: SettingsUseCase

    var selectedColorScheme: ColorScheme {
        return useCase.colorScheme
    }

    init(useCase: SettingsUseCase) {
        self.useCase = useCase
    }

    func selectColorScheme(_ scheme: ColorScheme) {
        useCase.colorScheme = scheme
    }
}
