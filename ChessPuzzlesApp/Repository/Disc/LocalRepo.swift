//
//  LocalRepo.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

import Foundation
import SwiftUI

protocol LocalRepo {
    var lightColor: ColorScheme { get set }
    var darkColor: ColorScheme { get set }
}

final class LocalRepoImpl: LocalRepo {
    @AppStorage("lightColor") var lightColor: ColorScheme = .light
    @AppStorage("darkColor") var darkColor: ColorScheme = .light
}
