//
//  HangmanGame.swift
//  Hangman
//
//  Created by Junyu Wang on 2/25/17.
//  Copyright © 2017 Shawn D'Souza. All rights reserved.
//

import Foundation

enum GameState: Int {
    case ongoing = 0
    case win, fail
}

class HangmanGame {
    
    var phrase: String
    var incorrectGuessesList: [String]
    var gameState: GameState
    var correctGuessesList: [String]
    
    let MAX_WRONG_GUSSES = 7
    
    init(_ phrase: String) {
        self.phrase = phrase.lowercased()
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
    
    func getNewGame(_ phrase: String) -> HangmanGame {
        return HangmanGame(phrase)
    }
    
    func getNumOfWrongGuesses() -> Int {
        return incorrectGuessesList.count
    }
}
