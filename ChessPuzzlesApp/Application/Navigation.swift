//
//  Navigation.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

import Foundation
import SwiftUI

final class Navigation: ObservableObject {
    private let factory: ScreenFactory
    
    @Published var path = NavigationPath()
    
    init(factory: ScreenFactory) {
        self.factory = factory
    }
    
    @ViewBuilder
    func createTabBar() -> some View {
        TabView {
            factory.viewFor(screen: .puzzles)
                .environmentObject(Navigation(factory: factory))
                .tabItem {
                    Label("Puzzles", systemImage: "menucard")
                }
        }
    }
    
    @ViewBuilder
    func viewFor(screen: Screen) -> some View {
        factory.viewFor(screen: screen)
    }
    
    func navigate(to screen: Screen) {
        path.append(screen)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

struct Navigate: ViewModifier {
    @EnvironmentObject private var navigation: Navigation
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Screen.self) { screen in
                navigation.viewFor(screen: screen)
            }
    }
}

extension View {
    func navigate() -> some View {
        modifier(Navigate())
    }
}
