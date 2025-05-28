//
//  CardView.swift
//  Laboratorna_3
//
//  Created by Raodgan on 28.03.2025.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    let viewModel: SetViewModel

    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2
        static let symbolPaddingRatio: CGFloat = 0.1
        static let symbolOpacity: Double = 0.4
        static let selectionColor: Color = .yellow
        static let matchColor: Color = .green
        static let mismatchColor: Color = .orange
        static let shapeStrokeLineWidth: CGFloat = 1.5
        static let stripedOverlayWidth: CGFloat = 1
    }

    var body: some View {
        GeometryReader { geometry in
            let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            ZStack {
                cardShape.fill(Color.white)
                cardShape.strokeBorder(borderColor, lineWidth: DrawingConstants.lineWidth * (card.isSelected ? 2 : 1))

                VStack {
                    ForEach(0..<card.number.rawValue, id: \.self) { _ in
                        styledSymbolView
                            .aspectRatio(symbolAspectRatio, contentMode: .fit)
                    }
                }
                .padding(geometry.size.width * DrawingConstants.symbolPaddingRatio)
            }
        }
    }

    private var borderColor: Color {
        if card.isSelected {
            if card.isMatched {
                return DrawingConstants.matchColor
            } else if card.isMismatch {
                return DrawingConstants.mismatchColor
            } else {
                return DrawingConstants.selectionColor
            }
        } else {
            return .gray
        }
    }

    @ViewBuilder
    private var styledSymbolView: some View {
        let color = viewModel.color(for: card)

        switch card.shape {
        case .v1:
            applyShadingToShape(Diamond(), shading: card.shading, color: color)
        case .v2:
            applyShadingToShape(Rectangle(), shading: card.shading, color: color)
        case .v3:
            applyShadingToShape(Capsule(), shading: card.shading, color: color)
        }
    }

    @ViewBuilder
    private func applyShadingToShape<S: Shape>(_ shape: S, shading: SetGame.Card.Variant, color: Color) -> some View {
        let opacity = DrawingConstants.symbolOpacity
        let strokeWidth = DrawingConstants.shapeStrokeLineWidth
        let stripedOverlayWidth = DrawingConstants.stripedOverlayWidth

        switch shading {
        case .v1:
            shape.fill(color)
        case .v2:
            ZStack {
                shape.fill(color.opacity(opacity))
                shape.stroke(color, lineWidth: stripedOverlayWidth)
            }
        case .v3:
            shape.stroke(color, lineWidth: strokeWidth)
        }
    }

    private var symbolAspectRatio: CGFloat { 2.0 / 1.0 }
}
