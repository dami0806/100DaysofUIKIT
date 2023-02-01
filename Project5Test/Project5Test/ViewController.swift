//
//  ViewController.swift
//  Project5Test
//
//  Created by 박다미 on 2023/02/01.
//


import UIKit

class ViewController: UITableViewController{
    
    var allWords = [String]() //파일에 있는 모든
    var usedWords = [String]()//플레이어가 현재 게임에서 사용한 모든 단어를 저장
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        // Restart Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        
    
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // All text
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    //게임 시작: allWords랜덤 작성했던 usedWord모두 제거, 테이블뷰 재로드
    @objc func startGame() {
        title = allWords.randomElement() // Word the player has to found
        usedWords.removeAll(keepingCapacity: true) // Remove all values in usedWords
        tableView.reloadData() // 반복적인 밑에 두 tableView 함수의 반복적인 실행에 대함
    }
    //테이블뷰에 작성글이 올라감
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    //셀
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    //답 쓰는 창을 add한다. 이거 하나니까 배열로 치면 0번째다.
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField() // Add a text field to the alert
        
        // 제출버튼을 누르면 answer에 사용자가 작성한 텍스트필드 0번째 내용이 들어간다. submit(answer) 출력
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in //action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        //단어가 유효한지 3가지 체크 다 소문자로 바꿈
        if isPossible(word: lowerAnswer){
            if isOriginal(word:lowerAnswer){
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer.lowercased(), at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                    //까지는 무조건 true일때 새배열 자동추가
                    
                }
                else {
                    showErrorMessage(errorTitle: "없는 단어입니다.", errorMessage: "이건 올라갈수 없는 답입니다!")
                }
            }
            else {
                showErrorMessage(errorTitle: "이미 나온 단어입니다.", errorMessage: "새로운단어를 말하세요!")
            }
        }
        else{
            
            guard let title = title?.lowercased() else {return}
            showErrorMessage(errorTitle: "주어진 철자가 아닙니다.", errorMessage: "\(title.lowercased())에 있는 철자가 아닙니다!")
 
            }
        }
        
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        //중복인지
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    // Check if the word is used
    //글자를 포함하는지
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    //실존하는 단어인지
    func isReal(word: String) -> Bool {
        guard let startWord = title?.lowercased() else { return false }

        
        let checker = UITextChecker() // An object you use to check a string for misspelled words.
        
        if word.count < 3 {
            showErrorMessage(errorTitle: "3글자이하.", errorMessage: "3글자 이상이여야 합니다")
            return false
        }
        
        if word == title {
            return false
        }
        let range = NSRange(location: 0, length: word.utf16.count)
        
        print(range.length)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound && startWord != word && range.length > 2
    }
    
    func showErrorMessage(errorTitle title: String, errorMessage message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}
