//
//  HangmanGame.swift
//  Hangman
//
//  Created by Junyu Wang on 2/25/17.
//  Copyright © 2017 Shawn D'Souza. All rights reserved.
//

import Foundation

class HangmanGame {
    
    enum GameState: Int {
        case ongoing = 0
        case win, fail
    }
    
    var phrase: String
    var phraseGenerator: HangmanPhrases
    var incorrectGuessesList: [String]
    var gameState: GameState
    var correctGuessesList: [String]
    
    let MAX_WRONG_GUSSES = 10
    
    init() {
        phraseGenerator = HangmanPhrases()
        phrase = phraseGenerator.getRandomPhrase()
        incorrectGuessesList = [String]()
        correctGuessesList = [String]()
        gameState = .ongoing
    }
    
    func guessLetter(_ letter: String) -> Bool {
        let hasLetter = phrase.contains(letter)
        correctGuessesList.append(letter)
        if hasLetter {
            return true
        } else {
            incorrectGuessesList.append(letter)
            return false
        }
    }
    
    func checkGameState() -> GameState {
        if incorrectGuessesList.count == MAX_WRONG_GUSSES {
            return .fail
        } else if correctGuessesList.count == Set(phrase.characters).count {
            return .win
        }
        return .ongoing
    }
    
    func newGame() -> HangmanGame {
        return HangmanGame()
    }
}
