//
//  ViewController.swift
//  project1Test
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    var lookingCount = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        loadPicture()
        let userDefaults = UserDefaults.standard
        lookingCount = userDefaults.object(forKey: "LookingCount") as? [String: Int] ?? [String: Int]()
        
        
       
        
    }
    func loadPicture(){
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
        // row 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text =  pictures[indexPath.row] //"Picture \(indexPath.row + 1) of \(pictures.count)"
        cell.detailTextLabel?.text = "조회수: \(lookingCount[pictures[indexPath.row],default: 0])"
        return cell
    }
    
    //선택후 넘기는 셀 storyboard의 identifier : Detail
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            vc.selectedImage = pictures[indexPath.row]
            vc.totalPictures = pictures.count
            vc.selectedPictureNumber = indexPath.row + 1
            lookingCount[pictures[indexPath.row],default: 0] += 1
            
            DispatchQueue.global().async {[weak self] in
                self?.saveViewCount()
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    func saveViewCount(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(lookingCount, forKey: "LookingCount")
    }
    


}

