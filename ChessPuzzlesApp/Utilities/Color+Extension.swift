//
//  Color+Extension.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 22. 9. 2025..
//

import SwiftUI

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
