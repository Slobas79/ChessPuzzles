//
//  ScreenFactory.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

import SwiftUI

enum Screen : Hashable {
    case tab1
}

final class ScreenFactory {
    private let container: DependencyInjectionContainer
    
    init(container: DependencyInjectionContainer) {
        self.container = container
    }
    
    func viewFor(screen: Screen) -> some View {
        switch screen {
        case .tab1:
            return AnyView(EmptyView())
        }
    }
}

struct EmptyView: View {
    var body: some View {
        Text("Under construction")
    }
}
