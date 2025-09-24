//
//  SettingsView.swift
//  ChessPuzzles
//
//  Created by Slobodan Stamenic on 23. 9. 2025..
//

import SwiftUI

struct SettingsView: View {
    var viewModel: SettingsViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Chess Board Colors")
                        .font(.headline)

                    ForEach(ColorScheme.allCases, id: \.self) { scheme in
                        ColorSchemeRow(
                            scheme: scheme,
                            isSelected: viewModel.selectedColorScheme == scheme,
                            onSelect: {
                                viewModel.selectColorScheme(scheme)
                            }
                        )
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct ColorSchemeRow: View {
    let scheme: ColorScheme
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(scheme.colors.0)
                        .frame(width: 30, height: 30)

                    Rectangle()
                        .fill(scheme.colors.1)
                        .frame(width: 30, height: 30)
                }
                .overlay(
                    Rectangle()
                        .stroke(Color.primary, lineWidth: 1)
                )

                VStack(alignment: .leading) {
                    Text(scheme.displayName)
                        .font(.body)
                        .foregroundColor(.primary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension ColorScheme: CaseIterable {
    public static var allCases: [ColorScheme] {
        [.classic, .brown]
    }

    var displayName: String {
        switch self {
        case .classic:
            return "Classic"
        case .brown:
            return "Brown"
        }
    }
}

