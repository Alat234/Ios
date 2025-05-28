//
//  SetViewModel.swift
//  Laboratorna_3
//
//  Created by Raodgan on 28.03.2025.
//

import SwiftUI

class SetViewModel: ObservableObject {
    @Published private(set) var model: SetGame

    init() {
        model = SetGame()
    }

    var cards: [SetGame.Card] {
        model.cardsInPlay
    }

    var deckIsEmpty: Bool {
        model.deck.isEmpty
    }

    var deckCount: Int {
        model.deck.count
    }

    var dealtCardCount: Int {
        model.dealtCardCount
    }

    func choose(_ card: SetGame.Card) {
        model.choose(card)
    }

    func dealThreeMoreCards() {
        model.dealThreeMoreCards()
    }

    func newGame() {
        model.newGame()
    }

    func color(for card: SetGame.Card) -> Color {
        switch card.color {
        case .v1: return .red
        case .v2: return .green
        case .v3: return .purple
        }
    }
}
