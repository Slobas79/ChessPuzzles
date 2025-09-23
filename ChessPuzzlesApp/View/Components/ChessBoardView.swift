//
//  ChessBoardView.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 20. 9. 2025..
//

import SwiftUI

struct ChessBoardView: View {
    var viewModel: ChessBoardViewModel
    
    public var body: some View {
        LazyVStack(spacing: 0) {
            LazyHStack(spacing: 0) {
                ForEach(0..<viewModel.size, id: \.self) { column in
                    Text("\(column)")
                        .frame(width: Const.cellS, height: Const.cellS, alignment: .trailing)
                }
            }
            LazyHStack(spacing: 0) {
                LazyVStack(spacing: 0) {
                    ForEach(0..<viewModel.size, id: \.self) { row in
                        Text("\(row)")
                            .frame(width: Const.cellS, height: Const.cellS, alignment: .center)
                    }
                }
                LazyVStack(spacing: 0) {
                    ForEach(0..<viewModel.size, id: \.self) { row in
                        LazyHStack(spacing: 0) {
                            ForEach(0..<viewModel.size, id: \.self) { column in
                                fieldButton(row: row, column: column,
                                            figure: viewModel.figures[Position(row: row, column: column)])
                            }
                        }
                    }
                }
                .border(.black, width: 3)
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func fieldButton(row: Int, column: Int, figure: Figure?) -> some View {
        Button {
            guard viewModel.invalidPosition == nil ||
                    viewModel.isInvalidPosition(row: row, column: column) else {
                return
            }
            if figure != nil {
                viewModel.selectFigure(at: Position(row: row, column: column))
            } else {
                viewModel.makeMoveTo(position: Position(row: row, column: column))
            }
        } label: {
            if let figure = figure {
                Image(systemName: figure.iconName)
                    .tint(viewModel.isInvalidPosition(row: row, column: column) ? .red : Const.figureColor)
                    .font(.system(size: Const.cellS/2))
                    .frame(width: Const.cellS, height: Const.cellS)
            } else {
                Text("")
                    .frame(width: Const.cellS, height: Const.cellS)
            }
        }
        .background((row + column) % 2 == 0 ? .white : .black)
    }
}

private struct Const {
    static let cellS: CGFloat = 40.0
    static let lightColor: Color = .white
    static let darkColor: Color = .black
    static let figureColor: Color = Color.mix(Self.darkColor, Self.lightColor)
}

