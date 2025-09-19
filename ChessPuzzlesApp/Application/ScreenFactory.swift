//
//  ScreenFactory.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

import SwiftUI

enum Screen : Hashable {
    case puzzles
    case nQueensOverview
}

final class ScreenFactory {
    private let container: DependencyInjectionContainer
    
    init(container: DependencyInjectionContainer) {
        self.container = container
    }
    
    func viewFor(screen: Screen) -> some View {
        switch screen {
        case .puzzles:
            return AnyView(PuzzlesView())
            case .nQueensOverview:
            return AnyView(NQueensOverviewView(viewModel:
                                                NQueensOverviewViewModel(nQueensRepo:
                                                                            container.nqRepoUseCase)))
        
        }
    }
}

struct EmptyView: View {
    var body: some View {
        Text("Under construction")
    }
}
