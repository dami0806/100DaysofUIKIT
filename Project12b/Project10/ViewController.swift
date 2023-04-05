//
//  ViewController.swift
//  Project10
//
//  Created by 박다미 on 2023/03/27.
//

import UIKit

class ViewController: UICollectionViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var people = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        self.navigationController?.delegate = self
        
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            }
            catch {
                print("Failed to load people")
            }
        }
    }
    @objc func addNewPerson() {
        //        let picker = UIImagePickerController()
        //        picker.allowsEditing = true
        //        picker.delegate = self
        //        present(picker, animated: true)
        //
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let ac = UIAlertController(title: "Source", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Photos", style: .default, handler: { [weak self] _ in
                self?.showPicker(fromCamera: false)
            }))
            ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                self?.showPicker(fromCamera: true)
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
            
            present(ac, animated: true)
        }
        else {
            showPicker(fromCamera: false)
        }
        
    }
    func showPicker(fromCamera: Bool) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if fromCamera {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as? PersonCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue PersonCell.")
        }
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        // if we're still here it means we got a PersonCell, so we can return it
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac = UIAlertController(title: "Person", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Rename person", style: .default, handler: { [weak self] action in
            self?.renamePersonTapped(person)
        }))
        ac.addAction(UIAlertAction(title: "Delete person", style: .destructive, handler: { [weak self] action in
            self?.deletePersonTapped(at: indexPath)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // provide the source for ipad compatibility
        if let popoverController = ac.popoverPresentationController {
            if let cellView = collectionView.cellForItem(at: indexPath) {
                popoverController.sourceView = cellView
                popoverController.sourceRect = CGRect(x: cellView.bounds.midX, y: cellView.bounds.midY, width: 0, height: 0)
            }
        }
        present(ac, animated: true)
    }
    // 이미지 피커에서 이미지를 선택하고 이미지가 선택되면 호출되는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            let imageName = UUID().uuidString
            let imagePath = self?.getDocumentsDirectory().appendingPathComponent(imageName)
            
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                if let imagePath = imagePath {
                    try? jpegData.write(to: imagePath)
                }
            }
            
            let person = Person(name: "Unknown", image: imageName)
            self?.people.append(person)
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.dismiss(animated: true)
            }
        }
    }
    
    // 문서 디렉토리 경로 반환 함수
    func getDocumentsDirectory() -> URL {
        // FileManager를 사용하여 문서 디렉토리 경로 반환
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func renamePersonTapped(_ person: Person) {
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {
                return
            }
            person.name = newName
            DispatchQueue.global().async {
                self?.save()
                
                DispatchQueue.main.async {
                    self?.save()
                    self?.collectionView.reloadData()
                }
            }
            //self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func deletePersonTapped(at indexPath: IndexPath) {
        let ac = UIAlertController(title: "Confirmation", message: "Delete person \"\(people[indexPath.item].name)\"?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.deletePerson(at: indexPath)
        }))
        
        present(ac, animated: true)
    }
    
    func deletePerson(at indexPath: IndexPath) {
        DispatchQueue.global().async { [weak self] in
            guard let image = self?.people[indexPath.item].image else {
                self?.showDeleteError()
                return
            }
            
            guard let imagePath = self?.getDocumentsDirectory().appendingPathComponent(image) else {
                self?.showDeleteError()
                return
            }
            
            do {
                try FileManager.default.removeItem(at: imagePath)
            }
            catch {
                self?.showDeleteError()
                return
            }
            
            // deletion ok
            self?.people.remove(at: indexPath.item)
            self?.save()
            
            DispatchQueue.main.async {
                self?.collectionView.deleteItems(at: [indexPath])
            }
        }
    }
    
    func showDeleteError() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Error", message: "Person could not be deleted", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            self?.present(ac, animated: true)
        }
    }
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(people){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
            
        }
        else {
            print("Failed to save people")
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 원하는 셀 크기를 CGSize 형태로 반환합니다.
        return CGSize(width: 140, height: 180)
    }
}




