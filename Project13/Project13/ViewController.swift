//
//  ViewController.swift
//  Project13
//
//  Created by 박다미 on 2023/04/07.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationBarDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    var currentImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
      
      
    }
    @objc func importPicture(){
        let picker = UIImagePickerController() //초기화
        picker.allowsEditing = true//선택한 이미지를 수정할 수 있는지 여부
        
        picker.delegate = self
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
            dismiss(animated: true)
        currentImage = image
    }

    @IBAction func changeFilter(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
    
    @IBAction func intensityChnage(_ sender: Any) {
    }
}

