//
//  ViewController.swift
//  Project4Test
//
//  Created by 박다미 on 2023/01/29.
//

import UIKit

class ViewController: UITableViewController {

    //웹사이트나열  --> 다음화면에 넘겨주기 (현재화면이랑, 배열전체)
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title넣기
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Using WebKit and ProgressBar"
    }
//table numberOfCells, cellForRowAt , didSelected 구성
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebsiteViewController") as! WebsiteViewController
        vc.websites = websites
        vc.currentWebsite = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}

