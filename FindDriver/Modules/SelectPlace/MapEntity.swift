//
//  MapEntity.swift
//  FindDriver
//
//  Created by Rain Moustfa on 24/08/2022.
//

import Foundation
import CoreLocation

struct MapEntity{
    var location:CLLocationCoordinate2D
    var address:String
    init() {
        location = CLLocationCoordinate2D()
        address = ""
    }
}
