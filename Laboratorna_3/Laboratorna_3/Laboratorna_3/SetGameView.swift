//
//  SetGameView.swift
//  Laboratorna_3
//
//  Created by Raodgan on 28.03.2025.
//

import SwiftUI

struct SetGameView: View {
    @StateObject var viewModel = SetViewModel()

    private let cardAspectRatio: CGFloat = 2.0 / 3.0
    private let spacing: CGFloat = 4

    var body: some View {
        VStack {
            Text("Set Game").font(.title)
            gameBody
            HStack {
                newGameButton
                Spacer()
                deckStatus
                Spacer()
                dealButton
            }
            .padding(.horizontal)
        }
        .padding(spacing)
    }

    private var gameBody: some View {
        AspectVGrid(viewModel.cards, aspectRatio: cardAspectRatio) { card in
             if card.isFaceUp {
                 CardView(card: card, viewModel: viewModel)
                    .padding(spacing)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
             }
        }
    }

    private var newGameButton: some View {
        Button("New Game") {
            viewModel.newGame()
        }
    }

    private var dealButton: some View {
        Button("Deal 3 More") {
            viewModel.dealThreeMoreCards()
        }
        .disabled(viewModel.deckIsEmpty)
    }

    private var deckStatus: some View {
        Text("Deck: \(viewModel.deckCount)")
            .font(.callout)
    }
}

struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView()
    }
}
