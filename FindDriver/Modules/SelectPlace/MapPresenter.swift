//
//  HomePresenter.swift
//  FindDriver
//
//  Created by Rain Moustfa on 24/08/2022.
//

import Foundation
import CoreLocation

protocol MapPresenterType {
    func onMapPresented(on mapView: MapViewControllerType)
    var location : CLLocationCoordinate2D{set get}
    var address :String{get}
    func navigateToDriver()
}

final class MapPresenter{
    private let interactor: MapInteractorType
    private let router: MapRouterType?
    weak var mapView: MapViewControllerType?
    
    var location: CLLocationCoordinate2D {
        didSet{
            interactor.updateLocation(location: oldValue)
            mapView?.setMapLocals(oldValue)
        }
    }
    
    init(interactor: MapInteractorType, router: MapRouterType) {
        self.interactor = interactor
        self.router = router
        self.location = CLLocationCoordinate2D()
    }
}

extension MapPresenter:MapPresenterType{
    func navigateToDriver() {
        router?.routeToDriver(from: mapView!,address: address)
    }
    
    var address: String {
        interactor.getAdress()
    }
    
    func onMapPresented(on mapView: MapViewControllerType) {
        self.mapView = mapView
    }
}
