//
//  ViewController.swift
//  Project13Challenge
//
//  Created by 박다미 on 2023/04/11.
//

import UIKit
import UIKit
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var intensity: UISlider!
    
    @IBOutlet weak var radius: UISlider!
    @IBOutlet weak var filterButton: UIButton!
    
    var context: CIContext!
    var currentFilter : CIFilter!
    var currentImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "필터입히기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        filterButton.setTitle("필터 : CIsepiaTone", for: .normal)
    }
    
    @IBAction func intensitySlide(_ sender: Any) {
           applyProcessing()
       
    }
    
    @IBAction func radiusSlide(_ sender: Any) {

           applyProcessing()
    }
    
    
    @IBAction func selectedFileter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style:.default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        filterButton.setTitle("필터 :  \(actionTitle)", for: .normal)

        applyProcessing()
    }
  
    func applyProcessing(){
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            // challenge 3
            currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
        }

        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }

        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
  
            guard let image = imageView.image else {
               
                let ac = UIAlertController(title: "저장에러", message: "저장할 이미지가 없습니다", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                return
            }
            UIImageWriteToSavedPhotosAlbum(image,self,#selector(image(_:didFinishSavingWithError:contextInfo:)),nil)
    }
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "저장에러발생", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "확인", style: .default))
            
        }
        else {
            let ac = UIAlertController(title: "저장되었습니다.", message: "바꾼 이미지가 앨범에 저장되었습니다.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "확인", style: .default))
            present(ac,animated: true)
        }
    }
 
  
    
}

