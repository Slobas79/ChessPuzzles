//
//  NQueensGameUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 19. 9. 2025..
//

final class NQueensGameUseCase: GameUseCase {
    func start(size: Int, name: String?) -> GameState {
        return GameState(size: size,
                         placedFigures: [],
                         name: name ?? "N-Queens \(size)x\(size)",
                         remainingFigures: [.queen : size],
                         canReset: false,
                         isSolved: false)
    }
    
    func reset(state: GameState) -> GameState {
        return GameState(size: state.size,
                         placedFigures: [],
                         name: state.name,
                         remainingFigures: [.queen : state.size],
                         canReset: false,
                         isSolved: false)
    }
    
    func selectOn(position: Position, state: GameState) -> GameState?
    {
        return remove(from: position, state: state)
    }
    
    func set(figure: Figure?, on position: Position, state: GameState) -> GameState {
        guard state.placedFigures.count < state.size else { return state }
        
        var newPlacedFigures = state.placedFigures
        newPlacedFigures.append(.init(position: position, figure: figure ?? .queen))
        return .init(size: state.size,
                     placedFigures: newPlacedFigures,
                     name: state.name,
                     remainingFigures: [.queen : state.size - newPlacedFigures.count],
                     canReset: !newPlacedFigures.isEmpty,
                     isSolved: state.size == newPlacedFigures.count)
    }
    
    // dragg and drop support
    func move(figure: Figure, from: Position, to: Position, state: GameState) -> GameState {
        var newPlacedFigures = state.placedFigures
        newPlacedFigures.removeAll(where: {$0.position == from})
        newPlacedFigures.append(.init(position: to, figure: figure))
        return .init(size: state.size,
                     placedFigures: newPlacedFigures,
                     name: state.name,
                     remainingFigures: [.queen : state.size - newPlacedFigures.count],
                     canReset: !newPlacedFigures.isEmpty,
                     isSolved: state.size == newPlacedFigures.count)
    }
    
    func remove(from: Position, state: GameState) -> GameState {
        var newPlacedFigures = state.placedFigures
        newPlacedFigures.removeAll(where: {$0.position == from})
        return .init(size: state.size,
                     placedFigures: newPlacedFigures,
                     name: state.name,
                     remainingFigures: [.queen : state.size - newPlacedFigures.count],
                     canReset: !newPlacedFigures.isEmpty,
                     isSolved: state.size == newPlacedFigures.count)
    }
}
