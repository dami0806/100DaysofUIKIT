//
//  ViewController.swift
//  Project1
//
//  Created by 박다미 on 2023/01/20.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        //url가져오기
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! //resourcePath: 리소스 파일이 포함된 번들 하위 디렉터리의 파일 URL
        let items = try! fm.contentsOfDirectory(atPath: path)//contentsOfDirectory() 함수: 디렉터리의 모든 항목을 문자열 배열의 항목 문자열 배열을 반환

        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                // this is a picture to load!
            }
        }
        // Do any additional setup after loading the view.
    }
    
    //여러개 행 표시
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    //셀을 대기열에서 빼기
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]

            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

