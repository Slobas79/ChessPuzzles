//
//  ObservationTracking.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 24. 9. 2025..
//

import Observation
import Foundation

// track changes of observable properties
public func withObservationTracking<T: Sendable>(of value: @Sendable @escaping @autoclosure () -> T, execute: @Sendable @escaping (T) -> Void) {
    Observation.withObservationTracking {
        execute(value())
    } onChange: {
        RunLoop.current.perform {
            withObservationTracking(of: value(), execute: execute)
        }
    }
}
