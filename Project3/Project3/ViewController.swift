//
//  ViewController.swift
//  Project3
//
//  Created by 박다미 on 2023/01/25.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort() //정렬
        
    }
    
    @objc func shareTapped() {
            let shareString = ["친구들이랑도 앱을 공유해보세요!!"]
            let shareUrl = URL(string: "https://www.stormViewer.com")
            
        let vc = UIActivityViewController(activityItems: [shareString, shareUrl!], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        
    }

    // row 개수
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text =  pictures[indexPath.row] //"Picture \(indexPath.row + 1) of \(pictures.count)"
    return cell
}

//선택후 넘기는 셀 storyboard의 identifier : Detail
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
        
        vc.selectedImage = pictures[indexPath.row]
        vc.totalPictures = pictures.count
        vc.selectedPictureNumber = indexPath.row + 1
        navigationController?.pushViewController(vc, animated: true)
    }
}




}
