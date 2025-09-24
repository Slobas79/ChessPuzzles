//
//  LocalRepo.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

import Foundation
import SwiftUI

protocol LocalRepo {
    var colorScheme: ColorScheme { get set }
}

final class LocalRepoImpl: LocalRepo {
    @AppStorage("colorScheme") var colorScheme: ColorScheme = .classic
}
