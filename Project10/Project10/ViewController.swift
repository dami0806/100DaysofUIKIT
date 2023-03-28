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
    }
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
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

        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName

            self?.collectionView.reloadData()
        })

        present(ac, animated: true)
    }
    // 이미지 피커에서 이미지를 선택하고 이미지가 선택되면 호출되는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된 이미지가 있으면
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // 이미지 파일 이름 생성
        let imageName = UUID().uuidString
        
        // 이미지 파일 경로 생성
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        // 이미지를 JPEG 형식의 데이터로 변환하고, 파일에 저장
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        // 이미지 선택창 닫기
        dismiss(animated: true)
    }

    // 문서 디렉토리 경로 반환 함수
    func getDocumentsDirectory() -> URL {
        // FileManager를 사용하여 문서 디렉토리 경로 반환
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 원하는 셀 크기를 CGSize 형태로 반환합니다.
        return CGSize(width: 140, height: 180)
    }
}




