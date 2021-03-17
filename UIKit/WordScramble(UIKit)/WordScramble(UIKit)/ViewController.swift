//
//  ViewController.swift
//  WordScramble(UIKit)
//
//  Created by Egor Chernakov on 04.03.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = ["silkworm"]
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: url) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(promptAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(startGame))
        
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll()
        tableView.reloadData()
    }
    
    @objc func promptAnswer() {
        let ac = UIAlertController(title: "Enter word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self, weak ac] _ in
            guard let word = ac?.textFields?[0].text else { return }
            self?.submitWord(word)
        }))
        present(ac, animated: true)
    }
    
    func submitWord(_ word: String) {
        if isPossible(word) && isOriginal(word) && isReal(word) {
            usedWords.insert(word, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func isPossible(_ word: String) -> Bool {
        guard var masterWord = title else {return false}
        for char in word {
            if let index = masterWord.firstIndex(of: char) {
                masterWord.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
}

//MARK: TableView Data Source
extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}

