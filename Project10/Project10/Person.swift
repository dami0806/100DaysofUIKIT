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
}
