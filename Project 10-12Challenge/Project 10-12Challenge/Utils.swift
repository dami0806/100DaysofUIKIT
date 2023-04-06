//
//  Utils.swift
//  Project 10-12Challenge
//
//  Created by 박다미 on 2023/04/06.
//

import Foundation
class Utils {
    static var pictureKey = "Pictures"
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    static func getImageURL(for imageName: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(imageName)
    }
    static func savePictures(pictures: [Picture]){
        if let encodedPicutres = try? JSONEncoder().encode(pictures){
            UserDefaults.standard.set(encodedPicutres, forKey: pictureKey)
        }
    }
 
    static func loadPictures() -> [Picture] {
        if let loadedPictures = UserDefaults.standard.object(forKey: pictureKey) as? Data {
            if let decodedPictures = try? JSONDecoder().decode([Picture].self, from: loadedPictures) {
                return decodedPictures
            }
        }
        
        return [Picture]()
    }
}
