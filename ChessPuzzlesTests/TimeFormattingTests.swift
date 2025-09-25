//
//  TimeFormatting.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 25. 9. 2025..
//

import Testing
@testable import ChessPuzzles

struct TimeFormatting {
    //MARK: Basic Formatting
    @Test("formatTime formats zero seconds correctly")
    func formatTimeFormatsZeroSecondsCorrectly() {
        let time: Double = 0.0
        let result = time.formatTime()
        #expect(result == "00:00")
    }
    
    @Test("formatTime formats seconds only")
    func formatTimeFormatsSecondsOnly() {
        let time: Double = 45.0
        let result = time.formatTime()
        #expect(result == "00:45")
    }
    
    @Test("formatTime formats single digit seconds with leading zero")
    func formatTimeFormatsSingleDigitSecondsWithLeadingZero() {
        let time: Double = 5.0
        let result = time.formatTime()
        #expect(result == "00:05")
    }
    
    @Test("formatTime formats exactly one minute")
    func formatTimeFormatsExactlyOneMinute() {
        let time: Double = 60.0
        let result = time.formatTime()
        #expect(result == "01:00")
    }
    
    @Test("formatTime formats minutes and seconds")
    func formatTimeFormatsMinutesAndSeconds() {
        let time: Double = 125.0 // 2 minutes 5 seconds
        let result = time.formatTime()
        #expect(result == "02:05")
    }
    
    @Test("formatTime formats double digit minutes and seconds")
    func formatTimeFormatsDoubleDigitMinutesAndSeconds() {
        let time: Double = 675.0 // 11 minutes 15 seconds
        let result = time.formatTime()
        #expect(result == "11:15")
    }
    
    //MARK: Negative Value Guard Tests
    @Test("formatTime returns 00:00 for negative values")
    func formatTimeReturns0000ForNegativeValues() {
        let negativeTime: Double = -30.0
        let result = negativeTime.formatTime()
        #expect(result == "00:00")
    }
    
    //MARK: Edge Cases
    @Test("formatTime handles decimal seconds by truncating")
    func formatTimeHandlesDecimalSecondsByTruncating() {
        let time: Double = 65.9
        let result = time.formatTime()
        #expect(result == "01:05") // Should truncate, not round
    }
    
    @Test("formatTime handles very small positive decimal values")
    func formatTimeHandlesVerySmallPositiveDecimalValues() {
        let time: Double = 0.9
        let result = time.formatTime()
        #expect(result == "00:00") // Less than 1 second
    }
    
    @Test("formatTime handles large time values")
    func formatTimeHandlesLargeTimeValues() {
        let time: Double = 3665.0 // 61 minutes 5 seconds
        let result = time.formatTime()
        #expect(result == "61:05")
    }
    
    @Test("formatTime handles very large time values")
    func formatTimeHandlesVeryLargeTimeValues() {
        let time: Double = 7265.0 // 121 minutes 5 seconds
        let result = time.formatTime()
        #expect(result == "121:05")
    }
}
