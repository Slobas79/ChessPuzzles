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
                    Text("\(columnLabel(column))")
                        .foregroundStyle(viewModel.colorScheme.colors.1)
                        .frame(width: Const.cellS, height: Const.cellS, alignment: .center)
                }
            }
            .padding(.leading, 30)
            
            LazyHStack(spacing: 0) {
                LazyVStack(spacing: 0) {
                    ForEach(0..<viewModel.size, id: \.self) { row in
                        Text("\(row + 1)")
                            .foregroundStyle(viewModel.colorScheme.colors.1)
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
                .border(viewModel.colorScheme.colors.1, width: 3)
            }
        }
        .padding(.trailing, 16)
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
                    .tint(viewModel.isInvalidPosition(row: row, column: column) ? .red : viewModel.colorScheme.colors.2)
                    .font(.system(size: Const.cellS/2))
                    .frame(width: Const.cellS, height: Const.cellS)
            } else {
                Text("")
                    .frame(width: Const.cellS, height: Const.cellS)
            }
        }
        .background((row + column) % 2 == 0 ? viewModel.colorScheme.colors.0 : viewModel.colorScheme.colors.1)
    }
    
    private func columnLabel(_ column: Int) -> String {
          if viewModel.size <= 26 {
              return String(Character(UnicodeScalar(65 + column)!)) // A-Z
          } else {
              return "\(column + 1)"
          }
      }

}

private struct Const {
    static let cellS: CGFloat = 40.0
}

