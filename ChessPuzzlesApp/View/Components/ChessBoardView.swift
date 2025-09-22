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
                                fieldButton(row: row, column: column, figure: viewModel.figures[Position(row: row, column: column)])
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
        VStack {
            Button {
//                viewModel.placeQueen(row: row, column: column)
            } label: {
                if let figure = figure {
                    Image(systemName: figure.iconName)
                        .tint(Const.figureColor)
                        .font(.system(size: Const.cellS/2))
                } else {
                    Text("")
                }
            }
        }
        .frame(width: Const.cellS, height: Const.cellS)
        .background((row + column) % 2 == 0 ? .white : .black)
    }
}

private struct Const {
    static let cellS: CGFloat = 40.0
    static let lightColor: Color = .white
    static let darkColor: Color = .black
    static let figureColor: Color = Color.mix(Self.darkColor, Self.lightColor)
}

extension Color {
    static func mix(_ color1: Color, _ color2: Color, by percentage: Double = 0.5) -> Color {
        let uiColor1 = UIColor(color1)
        let uiColor2 = UIColor(color2)
        
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        uiColor1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        uiColor2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let r = r1 + (r2 - r1) * percentage
        let g = g1 + (g2 - g1) * percentage
        let b = b1 + (b2 - b1) * percentage
        let a = a1 + (a2 - a1) * percentage
        
        return Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
