//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
    
    @IBOutlet weak var gameStateImage: UIImageView!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var phraseLabel: UILabel!
    
    var game: HangmanGame = HangmanGame("")
    var wordsLabels: [UILabel] = [UILabel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hangmanPhrases = HangmanPhrases()
        let phrase: String = hangmanPhrases.getRandomPhrase()
        print(phrase)
        
        game = game.getNewGame(phrase)
        setGameStateImage(index: 0)
        setUpPhraseLabel(phrase)
    }
    
    func setGameStateImage(index: Int) {
        let imageName: String = "hangman" + String(index)
        gameStateImage.image = UIImage(named: imageName)
    }
    
    func setUpPhraseLabel(_ phrase: String) {
        let numLetters: Int = phrase.characters.count
        var text: String = ""
        for _ in 1...numLetters {
            text += "_"
        }
        self.phraseLabel.text = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func guessButtonWasPressed(_ sender: UIButton) {
        if let letter = guessTextField.text {
            if !game.guessLetter(letter) {
                updateIncorrectGuesses(letter)
                let numWrongGuesses: Int = game.getNumOfWrongGuesses()
                setGameStateImage(index: numWrongGuesses)
            } else {
                updatePhraseLabel(with: letter)
            }
        }
        clearGuessInputField()
        let gameState: GameState = game.checkGameState()
        switch gameState {
        case .win:
            // show win message
            break
        case .fail:
            break
        default:
            break
        }
    }
    
    func updatePhraseLabel(with letter: String) {
        let phraseArray = game.phrase.characters.map { String($0) }
        let numLetters = phraseArray.count
        var lettersInLabel = phraseLabel.text?.characters.map { String($0) }
        for pos in 0...(numLetters-1) {
            let ch = phraseArray[pos]
            if letter == ch {
                lettersInLabel?[pos] = letter
            }
        }
        let newLabelText: String = (lettersInLabel?.joined())!
        self.phraseLabel.text = newLabelText
    }
    

    func clearGuessInputField() {
        guessTextField.text = ""
    }
    
    func updateIncorrectGuesses(_ letter: String) {
        if let text = incorrectGuessesLabel.text {
            let newLabel = "\(text) \(letter)"
            incorrectGuessesLabel.text = newLabel
        }
    }
}
