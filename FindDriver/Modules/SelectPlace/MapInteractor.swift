//
//  MapInteractor.swift
//  FindDriver
//
//  Created by Rain Moustfa on 24/08/2022.
//

import Foundation
import CoreLocation

protocol MapInteractorType {
    var mapEntity:MapEntity{set get}
    func getAdress()->String
    func updateLocation(location:CLLocationCoordinate2D)
}

class MapInteractor: MapInteractorType {
    var mapEntity: MapEntity
    
    init (mapEntity: MapEntity) {
        self.mapEntity = mapEntity
    }
    
    func getAdress() -> String {
        return mapEntity.address
    }
    
    func updateLocation(location:CLLocationCoordinate2D){
        mapEntity.location = location
        getAddressFromLatLon(location: location)
    }
    
    func getAddressFromLatLon(location:CLLocationCoordinate2D) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = location.latitude
        center.longitude = location.longitude
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc) {(placemarks, error) in
            if (error != nil) { return }
            let pm = placemarks! as [CLPlacemark]
            (pm.count > 0 ) ? self.reverseGeoLocation(pm: placemarks![0]) : nil
        }
    }
    
    private func reverseGeoLocation(pm:CLPlacemark){
        let addressString = "\( pm.subLocality ?? "") ,\(pm.thoroughfare ?? "") ,\( pm.locality ?? "") , \(pm.country ?? "")"
        if !addressString.isEmpty {
            self.mapEntity.address = addressString
        }
    }
}
