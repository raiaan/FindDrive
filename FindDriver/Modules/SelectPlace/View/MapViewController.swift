//
//  MapViewController.swift
//  FindDriver
//
//  Created by Rain Moustfa on 24/08/2022.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel

protocol MapViewControllerType: AnyObject {
    func setMapLocals(_ locValue: CLLocationCoordinate2D)
    var floatingPanelController:FloatingPanelController{get}
}

class MapViewController: UIViewController ,MapViewControllerType , FloatingPanelControllerDelegate{
    var presenter: MapPresenterType!
    @IBOutlet weak var myMapView: MKMapView!
    let locationManager = CLLocationManager()
    var floatingPanelController: FloatingPanelController = FloatingPanelController()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle? , presenter:MapPresenterType) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.presenter.onMapPresented(on: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocationManager()
        configFloatingController()
    }
    
    @IBAction func presentDriver(_ sender: Any) {
        self.presenter.navigateToDriver()
    }
    
    private func configFloatingController(){
        floatingPanelController.delegate = self
    }
}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        configMap(locValue)
        presenter.location = locValue
    }
    
    func configLocationManager(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
}

extension MapViewController: MKMapViewDelegate{
    
    func setMapLocals(_ locValue: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        myMapView.setRegion(region, animated: true)
        drowAnnotation(locValue: locValue)
    }
    
    private func drowAnnotation(locValue: CLLocationCoordinate2D, address:String = ""){
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        myMapView.addAnnotation(annotation)
    }
    
    func configMap(_ locValue: CLLocationCoordinate2D){
        myMapView.delegate = self
        myMapView.isZoomEnabled = true
        myMapView.isScrollEnabled = true
        myMapView.showsCompass = true
        myMapView.showsBuildings = true
        myMapView.mapType = .standard
        myMapView.setCenter(locValue, animated: true)
        self.presenter.location = myMapView.centerCoordinate
        zoomLocation(latitude: locValue.latitude, longitude:  locValue.longitude)
    }
    
    func zoomLocation(latitude:Double , longitude:Double){
        let oahuCenter = CLLocation(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(
            center: oahuCenter.coordinate,
            latitudinalMeters: .greatestFiniteMagnitude,
            longitudinalMeters: .greatestFiniteMagnitude)
        myMapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: .greatestFiniteMagnitude)
        myMapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView:MKAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView!.isDraggable = true;
            annotationView?.image = UIImage(named: "user-map")
        }else{
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView( _ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.myMapView.removeAnnotations(myMapView.annotations)
        self.drowAnnotation(locValue: mapView.centerCoordinate)
    }
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, didChange: MKAnnotationView.DragState, fromOldState: MKAnnotationView.DragState){
        if didChange.rawValue == MKAnnotationView.DragState.ending.rawValue {
            if let coordinate = annotationView.annotation?.coordinate {
                self.presenter.location = coordinate
            }
        }
    }
}
