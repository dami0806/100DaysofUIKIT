//
//  ViewController.swift
//  Project5
//
//  Created by 박다미 on 2023/01/30.
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
    }
    
}
