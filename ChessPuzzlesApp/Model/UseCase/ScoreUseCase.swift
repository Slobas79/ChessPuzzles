//
//  ScoreUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 24. 9. 2025..
//

protocol ScoreUseCase {
    var bestTime: Double { get }
    func setBestTime(_ time: Double)
}

final class ScoreUseCaseImpl: ScoreUseCase {
    private var localRepo: LocalRepo
    
    var bestTime: Double {
        get {
            localRepo.bestTime
        }
    }
    
    func setBestTime(_ time: Double) {
        if time < bestTime {
            localRepo.bestTime = time
        }
    }
    
    init(localRepo: LocalRepo) {
        self.localRepo = localRepo
    }
}
