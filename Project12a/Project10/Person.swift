//
//  Person.swift
//  Project10
//
//  Created by 박다미 on 2023/03/28.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    //UserDefaults는 내부적으로 NSCoding 프로토콜을 사용하여 데이터를 저장
    
    //NSCoder 프로토콜을 따르는 초기화 메서드입니다. 이를 통해 클래스 객체가 데이터로부터 초기화될 때 호출. 디코딩된 데이터에서 name과 image 프로퍼티를 가져와 초기화합니다.
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
 

    // NSCoder 프로토콜을 따르는 인코딩 메서드입니다. 클래스 객체를 데이터로 변환할 때 호출.  name과 image 프로퍼티를 인코딩하여 데이터에 추가
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
