//
//  ChessPuzzlesApp.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

import SwiftUI

@main
struct ChessPuzzlesApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(Navigation(factory: ScreenFactory(container: DependencyInjectionContainer())))
        }
    }
}
