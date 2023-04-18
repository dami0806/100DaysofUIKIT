//
//  Capital.swift
//  Project16-1
//
//  Created by 박다미 on 2023/04/18.
//

import UIKit
import MapKit

class Capital: NSObject,MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }

}
