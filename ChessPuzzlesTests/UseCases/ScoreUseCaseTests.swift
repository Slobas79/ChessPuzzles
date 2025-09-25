//
//  ScoreUseCaseTests.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 25. 9. 2025..
//

import Testing
@testable import ChessPuzzles

struct ScoreUseCaseTests {
    final class MockLocalRepo: LocalRepo {
        var colorScheme: ColorScheme = .classic
        var bestTime: Double = 75.0
    }
    
    
    //MARK: bestTime get
    @Test("bestTime returns value from local repo")
    func bestTimeReturnsValueFromLocalRepo() {
        let mockRepo = MockLocalRepo()
        mockRepo.bestTime = 42.5
        let scoreUseCase = ScoreUseCaseImpl(localRepo: mockRepo)
        
        #expect(scoreUseCase.bestTime == 42.5)
    }
    
    @Test("bestTime reflects changes in local repo")
    func bestTimeReflectsChangesInLocalRepo() {
        let mockRepo = MockLocalRepo()
        let scoreUseCase = ScoreUseCaseImpl(localRepo: mockRepo)
        
        // Initial value
        #expect(scoreUseCase.bestTime == 75.0)
        
        // Change repo value directly
        mockRepo.bestTime = 30.0
        #expect(scoreUseCase.bestTime == 30.0)
        
        // Change again
        mockRepo.bestTime = 120.5
        #expect(scoreUseCase.bestTime == 120.5)
    }
    
    // MARK: setBestTime
    
    @Test("setBestTime updates when new time is better")
    func setBestTimeUpdatesWhenNewTimeIsBetter() {
        let mockRepo = MockLocalRepo()
        mockRepo.bestTime = 60.0
        let scoreUseCase = ScoreUseCaseImpl(localRepo: mockRepo)
        
        scoreUseCase.setBestTime(45.0)
        
        #expect(mockRepo.bestTime == 45.0)
        #expect(scoreUseCase.bestTime == 45.0)
    }
    
    @Test("setBestTime does not update when new time is worse")
    func setBestTimeDoesNotUpdateWhenNewTimeIsWorse() {
        let mockRepo = MockLocalRepo()
        mockRepo.bestTime = 60.0
        let scoreUseCase = ScoreUseCaseImpl(localRepo: mockRepo)
        
        scoreUseCase.setBestTime(75.0)
        
        #expect(mockRepo.bestTime == 60.0)
        #expect(scoreUseCase.bestTime == 60.0)
    }
    
    @Test("setBestTime does not update when new time equals current best")
    func setBestTimeDoesNotUpdateWhenNewTimeEqualsCurrentBest() {
        let mockRepo = MockLocalRepo()
        mockRepo.bestTime = 60.0
        let scoreUseCase = ScoreUseCaseImpl(localRepo: mockRepo)
        
        scoreUseCase.setBestTime(60.0)
        
        #expect(mockRepo.bestTime == 60.0)
        #expect(scoreUseCase.bestTime == 60.0)
    }
    
    @Test("setBestTime works with zero time")
    func setBestTimeWorksWithZeroTime() {
        let mockRepo = MockLocalRepo()
        mockRepo.bestTime = 60.0
        let scoreUseCase = ScoreUseCaseImpl(localRepo: mockRepo)
        
        scoreUseCase.setBestTime(0.0)
        
        #expect(mockRepo.bestTime == 60.0)
        #expect(scoreUseCase.bestTime == 60.0)
    }
    
    @Test("Multiple setBestTime calls with improving times")
    func multipleBestTimeCallsWithImprovingTimes() {
        let mockRepo = MockLocalRepo()
        mockRepo.bestTime = 100.0
        let scoreUseCase = ScoreUseCaseImpl(localRepo: mockRepo)
        
        let times = [90.0, 80.0, 70.0, 60.0, 50.0]
        
        for time in times {
            scoreUseCase.setBestTime(time)
            #expect(scoreUseCase.bestTime == time)
        }
        
        #expect(mockRepo.bestTime == 50.0)
    }
    
    @Test("Multiple setBestTime calls with mixed times")
    func multipleBestTimeCallsWithMixedTimes() {
        let mockRepo = MockLocalRepo()
        mockRepo.bestTime = 60.0
        let scoreUseCase = ScoreUseCaseImpl(localRepo: mockRepo)
        
        // Mix of better and worse times
        scoreUseCase.setBestTime(70.0) // Worse - should not update
        #expect(scoreUseCase.bestTime == 60.0)
        
        scoreUseCase.setBestTime(45.0) // Better - should update
        #expect(scoreUseCase.bestTime == 45.0)
        
        scoreUseCase.setBestTime(50.0) // Worse - should not update
        #expect(scoreUseCase.bestTime == 45.0)
        
        scoreUseCase.setBestTime(30.0) // Better - should update
        #expect(scoreUseCase.bestTime == 30.0)
        
        #expect(mockRepo.bestTime == 30.0)
    }
}
