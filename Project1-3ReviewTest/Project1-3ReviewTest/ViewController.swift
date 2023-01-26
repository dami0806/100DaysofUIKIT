//
//  ViewController.swift
//  Project1-3ReviewTest
//
//  Created by 박다미 on 2023/01/26.
//

import UIKit

class ViewController: UITableViewController{

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "여러나라 국기들"
        navigationController?.navigationBar.prefersLargeTitles = true
        //국기 이름 나열
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("png"){
                
                pictures.append(item)
            }
        }
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        
    }
    //셀 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    //셀 구성
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
        
    }
    
    //셀 클릭시 동작
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            vc.selectedFlag = pictures[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

