//
//  MapView+centerToLocation.swift
//  FindDriver
//
//  Created by Rain Moustfa on 24/08/2022.
//

import Foundation
import MapKit
extension MKMapView {
  func centerToLocation( _ location: CLLocation,regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
