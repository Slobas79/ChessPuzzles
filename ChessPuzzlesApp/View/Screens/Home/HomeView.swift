//
//  HomeView.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

import SwiftUI
struct HomeView: View {
    @EnvironmentObject  var navigation: Navigation
    
    var body: some View {
        navigation.createTabBar()
    }
}

#Preview {
    HomeView()
}
