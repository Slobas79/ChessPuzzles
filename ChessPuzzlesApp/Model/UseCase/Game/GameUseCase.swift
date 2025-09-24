//
//  GameUseCase.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 22. 9. 2025..
//

protocol GameUseCase {
    func start(size: Int, name: String?) -> GameState
    func reset(state: GameState) -> GameState
    func selectOn(position: Position, state: GameState) -> GameState?
    func set(figure: Figure?, on position: Position, state: GameState) -> GameState
    func move(figure: Figure, from: Position, to: Position, state: GameState) -> GameState
    func remove(from: Position, state: GameState) -> GameState
}
