//
//  ViewController.swift
//  GuessTheFlag(UIKit)
//
//  Created by Egor Chernakov on 03.03.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = ["US", "Estonia", "France", "Russia", "Italy", "Germany", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ireland"]
    var score = 0
    var highestScore: Int! {
        didSet {
            UserDefaults.standard.set(highestScore, forKey: "score")
        }
    }
    var correctAnswer = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highestScore = UserDefaults.standard.integer(forKey: "score")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(scoreButtonTapped))
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }

    func askQuestion() {
        questionsAsked += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = "Pick \(countries[correctAnswer])"
        button1.setImage(UIImage(named: countries[0].lowercased()), for: .normal)
        button2.setImage(UIImage(named: countries[1].lowercased()), for: .normal)
        button3.setImage(UIImage(named: countries[2].lowercased()), for: .normal)
    }
    
    @objc func scoreButtonTapped() {
        let ac = UIAlertController(title: "Your score is \(score)", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title = ""
        var message = ""
        
        if correctAnswer == sender.tag {
            score += 1
            title = "Correct!"
            message = "Your score is \(score)"
        } else {
            score -= 1
            title = "Wrong"
            message = "That's the flag of \(countries[sender.tag])"
        }
        
        if questionsAsked == 10 {
            title = "Congratulations!"
            message = "Your final score is \(score)."
            
            if score > highestScore {
                title = "Wow!"
                message = "You achieved a new high score of \(score)"
                highestScore = score
            }
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: {_ in
                    self.questionsAsked = 0
                    self.askQuestion()
            }))
            
            present(ac, animated: true)
            
            return
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in self.askQuestion()}))
        
        present(ac, animated: true)
    }
}

