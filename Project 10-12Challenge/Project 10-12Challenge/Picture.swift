//
//  Picture.swift
//  Project 10-12Challenge
//
//  Created by 박다미 on 2023/04/06.
//

import Foundation

class Picture: Codable {
    var imageName: String
    var caption:String
    
    init(imageName: String, caption: String){
        self.imageName = imageName
        self.caption = caption
        
    }
}
