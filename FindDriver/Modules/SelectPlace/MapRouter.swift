//
//  MapRouter.swift
//  FindDriver
//
//  Created by Rain Moustfa on 24/08/2022.
//

import Foundation
import UIKit

protocol MapRouterType: AnyObject {
    func routeToDriver(from: MapViewControllerType,address:String)
}

class MapRouter: MapRouterType {
    var driver :DriverViewController = DriverViewController(nibName: nil, bundle: nil, address: "")
    func routeToDriver(from view: MapViewControllerType,address:String) {
        if let mapView = (view as? MapViewController){
            mapView.floatingPanelController.layout = TextLocationFloatingPanelLayout()
            driver.address = address
            mapView.floatingPanelController.set(contentViewController: driver)
            mapView.floatingPanelController.isRemovalInteractionEnabled = true
            mapView.present(mapView.floatingPanelController, animated: true)
        }
    }

}
