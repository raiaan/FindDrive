//
//  MapRouter.swift
//  FindDriver
//
//  Created by Rain Moustfa on 24/08/2022.
//

import Foundation
import UIKit
import FloatingPanel

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

class TextLocationFloatingPanelLayout: FloatingPanelLayout{
    var position: FloatingPanelPosition = .bottom
    
    var initialState: FloatingPanelState = .full
    
    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring]{
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}

