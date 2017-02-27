//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var gameStateImage: UIImageView!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var guessButton: UIButton!
    
    var game: HangmanGame = HangmanGame("")
    var wordsLabels: [UILabel] = [UILabel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
        guessTextField.delegate = self
    }
    
    func getNewPhrase() -> String {
        let hangmanPhrases = HangmanPhrases()
        let phrase: String = hangmanPhrases.getRandomPhrase()
        print(phrase)
        return phrase
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
        self.phraseLabel.attributedText = createPhraseAttributedString(with: text)
    }
    
    func createPhraseAttributedString(with phrase: String) -> NSMutableAttributedString {
        let str: NSMutableAttributedString = NSMutableAttributedString(string: phrase)
        str.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, str.length))
        return str
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startNewGame() {
        let phrase: String = getNewPhrase()
        game = game.getNewGame(phrase)
        setGameStateImage(index: 0)
        incorrectGuessesLabel.text = "Incorrect Guesses:"
        setUpPhraseLabel(phrase)
        guessButton.isEnabled = true
    }
    
    @IBAction func startOverButtonWasPressed(_ sender: UIButton) {
        startNewGame()
    }

    @IBAction func guessButtonWasPressed(_ sender: UIButton) {
        if let letter = guessTextField.text {
            if letter != "" && !game.guessLetter(letter) {
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
        case .ongoing:
            break
        default:
            showPopUpWithGameState(gameState)
            guessButton.isEnabled = false
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 1
    }
    
    func showPopUpWithGameState(_ state: GameState) {
        let title: String = state == .win ? "You Win!" : "Game Over"
        let message: String = state == .win ? "Congratulations!" : "Let's do a new one!"
        let alertController: UIAlertController = UIAlertController(title: title,
                                                                   message: message,
                                                                   preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertActionStyle.default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updatePhraseLabel(with letter: String) {
        let phraseArray = game.phrase.characters.map { String($0) }
        let numLetters = phraseArray.count
        var lettersInLabel = phraseLabel.attributedText?.string.characters.map { String($0) }
        for pos in 0...(numLetters-1) {
            let ch = phraseArray[pos]
            if letter == ch {
                lettersInLabel?[pos] = letter
            }
        }
        let newLabelText: String = (lettersInLabel?.joined())!
        self.phraseLabel.attributedText = createPhraseAttributedString(with: newLabelText)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
