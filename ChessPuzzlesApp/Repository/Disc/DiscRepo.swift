//
//  DiscRepo.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 18. 9. 2025..
//

import Foundation
import SwiftUI

protocol DiscRepo {
    var example: Bool { get set }
}

final class DiscRepoImpl: DiscRepo {
    @AppStorage("example") var example = false
}
