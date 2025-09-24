//
//  ScreenFactory.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

import SwiftUI

enum Screen : Hashable {
    case empty
    case puzzles
    case settings
    case nQueensOverview
    case nQueensGame(GameState?)
}

final class ScreenFactory {
    private let container: DependencyInjectionContainer
    
    init(container: DependencyInjectionContainer) {
        self.container = container
    }
    
    func viewFor(screen: Screen) -> some View {
        switch screen {
        case .empty:
            return AnyView(EmptyView())
        case .puzzles:
            return AnyView(PuzzlesView())
        case .nQueensOverview:
            return AnyView(NQueensOverviewView(viewModel:
                                                NQueensOverviewViewModel(nQueensRepo:
                                                                            container.nqRepoUseCase)))
        case .settings:
            return AnyView(SettingsView(viewModel: SettingsViewModel(useCase: container.settingsUseCase)))
        case .nQueensGame(let state):
            return AnyView(NQueensGameView(viewModel:
                                            NQueensGameViewModel(validationUseCase: container.nqValidatorUseCase,
                                                                 nQueensUseCase: container.nQueensGameUseCase, settingsUseCase: container.settingsUseCase,
                                                                 state: state)))
        }
    }
}

struct EmptyView: View {
    var body: some View {
        Text("Under construction")
    }
}
