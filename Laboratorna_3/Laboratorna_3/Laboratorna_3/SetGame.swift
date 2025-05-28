//
//  SetGame.swift
//  Laboratorna_3
//
//  Created by Raodgan on 28.03.2025.
//

import Foundation

struct SetGame {
    private(set) var deck: [Card]
    private(set) var cardsInPlay: [Card]
    var selectedCards: [Card] {
        cardsInPlay.filter { $0.isSelected }
    }
    private(set) var dealtCardCount: Int

    struct Card: Identifiable, Equatable {
        let id = UUID()
        let number: Variant
        let shape: Variant
        let shading: Variant
        let color: Variant

        var isSelected = false
        var isMatched = false
        var isMismatch = false
        var isFaceUp = false

        enum Variant: Int, CaseIterable {
            case v1 = 1, v2, v3

            static func isSetFeature(v1: Variant, v2: Variant, v3: Variant) -> Bool {
                return (v1 == v2 && v2 == v3) || (v1 != v2 && v1 != v3 && v2 != v3)
            }
        }

        static func == (lhs: Card, rhs: Card) -> Bool {
            lhs.number == rhs.number &&
            lhs.shape == rhs.shape &&
            lhs.shading == rhs.shading &&
            lhs.color == rhs.color
        }
    }

    init(initialDealCount: Int = 12) {
        deck = SetGame.createDeck()
        cardsInPlay = []
        dealtCardCount = max(0, min(initialDealCount, deck.count))
        dealInitialCards()
    }

    private static func createDeck() -> [Card] {
        var newDeck = [Card]()
        for number in Card.Variant.allCases {
            for shape in Card.Variant.allCases {
                for shading in Card.Variant.allCases {
                    for color in Card.Variant.allCases {
                        newDeck.append(Card(number: number, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
        return newDeck.shuffled()
    }

    private mutating func dealInitialCards() {
        deck.shuffle()
        cardsInPlay.removeAll()
        for _ in 0..<dealtCardCount {
            if let card = deck.popLast() {
                cardsInPlay.append(card.facedUp())
            }
        }
    }

    mutating func choose(_ card: Card) {
        guard let chosenIndex = cardsInPlay.firstIndex(where: { $0.id == card.id }) else {
            return
        }

        let currentlySelectedIndices = cardsInPlay.indices.filter { cardsInPlay[$0].isSelected }
        let isSetSelected = currentlySelectedIndices.count == 3 && isSet(indices: currentlySelectedIndices)

        if currentlySelectedIndices.count == 3 {
            let wasMatch = isSetSelected

            for index in currentlySelectedIndices {
                cardsInPlay[index].isSelected = false
                cardsInPlay[index].isMatched = false
                cardsInPlay[index].isMismatch = false
            }

            if wasMatch {
                replaceOrRemoveMatchedCards(indices: currentlySelectedIndices)
                if !currentlySelectedIndices.contains(chosenIndex) {
                     if let newChosenIndex = cardsInPlay.firstIndex(where: { $0.id == card.id }) {
                         cardsInPlay[newChosenIndex].isSelected = true
                     }
                }
            } else {
                cardsInPlay[chosenIndex].isSelected = true
            }

        } else {
            if cardsInPlay[chosenIndex].isSelected {
                 cardsInPlay[chosenIndex].isSelected = false
            } else {
                cardsInPlay[chosenIndex].isSelected = true
                let nowSelectedIndices = cardsInPlay.indices.filter { cardsInPlay[$0].isSelected }

                if nowSelectedIndices.count == 3 {
                    if isSet(indices: nowSelectedIndices) {
                        // Це Сет
                        for index in nowSelectedIndices {
                            cardsInPlay[index].isMatched = true
                            cardsInPlay[index].isMismatch = false
                        }
                    } else {
                        // Це НЕ Сет
                        for index in nowSelectedIndices {
                            cardsInPlay[index].isMatched = false
                            cardsInPlay[index].isMismatch = true
                        }
                    }
                }
            }
        }
    }

    mutating func dealThreeMoreCards() {
        let selectedIndices = cardsInPlay.indices.filter { cardsInPlay[$0].isSelected }
        let isSetCurrentlySelected = selectedIndices.count == 3 && isSet(indices: selectedIndices)

        if isSetCurrentlySelected {
            replaceOrRemoveMatchedCards(indices: selectedIndices)
        } else if !deck.isEmpty {
            for _ in 0..<3 {
                if let card = deck.popLast() {
                    cardsInPlay.append(card.facedUp())
                }
                if deck.isEmpty { break }
            }
        }
    }

    mutating func newGame() {
        deck = SetGame.createDeck()
        cardsInPlay.removeAll()
        dealInitialCards()
    }


    private func isSet(indices: [Int]) -> Bool {
        guard indices.count == 3 else { return false }
        guard let card1 = cardsInPlay[safe: indices[0]],
              let card2 = cardsInPlay[safe: indices[1]],
              let card3 = cardsInPlay[safe: indices[2]] else {
            return false
        }

        let numberIsSet = Card.Variant.isSetFeature(v1: card1.number, v2: card2.number, v3: card3.number)
        let shapeIsSet = Card.Variant.isSetFeature(v1: card1.shape, v2: card2.shape, v3: card3.shape)
        let shadingIsSet = Card.Variant.isSetFeature(v1: card1.shading, v2: card2.shading, v3: card3.shading)
        let colorIsSet = Card.Variant.isSetFeature(v1: card1.color, v2: card2.color, v3: card3.color)

        return numberIsSet && shapeIsSet && shadingIsSet && colorIsSet
    }

    private mutating func replaceOrRemoveMatchedCards(indices: [Int]) {
        let sortedIndices = indices.sorted(by: >)

        for index in sortedIndices {
            guard cardsInPlay.indices.contains(index) else { continue }

            if !deck.isEmpty {
                cardsInPlay[index] = deck.removeLast().facedUp()
            } else {
                cardsInPlay.remove(at: index)
            }
        }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension SetGame.Card {
    func facedUp() -> SetGame.Card {
        var card = self
        card.isFaceUp = true
        return card
    }
}
