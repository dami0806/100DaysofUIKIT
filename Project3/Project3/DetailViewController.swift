//
//  DetailViewController.swift
//  Project3
//
//  Created by 박다미 on 2023/01/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: String? //이미지 이름
    var selectedPictureNumber = 0///선택된 이미지 인덱스
    var totalPictures = 0//총 이미지
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Picture \(selectedPictureNumber) of \(totalPictures)"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        
        
        
       
        if let imageTLoad = selectedImage {
            imageView.image = UIImage(named: imageTLoad)
        }
    }
  
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.hidesBarsOnTap = true
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.hidesBarsOnTap = false
        }
    @objc func shareTapped(){
        
        //사용자 지정 사진 공유
      guard let image = imageView.image?.jpegData(compressionQuality: 0.8)
        else{
            print("No image found")
            return
        }
        guard let imageName = selectedImage else {
            print("No image name found")
            return
        }
        //UIActivityViewContrller 생성해서 이미지를 공유하고 싶다고 말하는 것
        //let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        
        
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
}
