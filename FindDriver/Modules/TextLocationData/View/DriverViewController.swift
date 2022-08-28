//
//  DriverViewController.swift
//  FindDriver
//
//  Created by Rain Moustfa on 24/08/2022.
//

import UIKit
import FloatingPanel

protocol DriverViewControllerType{
    var presenter : DriverPresenterType{set get}
}
enum AddressType{
    case pickupLocation
    case destinationLocation
}
class DriverViewController: UIViewController ,FloatingPanelControllerDelegate{
    
    @IBOutlet weak var toLocation: UITextField!
    @IBOutlet weak var fromLocation: UITextField!
    var floatingPanelController: FloatingPanelController = FloatingPanelController()
    var addresstypeToRecieve = AddressType.pickupLocation
    var address:String = ""
    func updateAdrress(address:String){
        switch addresstypeToRecieve {
        case .pickupLocation:
            fromLocation.text = address
        case .destinationLocation:
            toLocation.text = address
        }
    }
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?,address:String ) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.address = address
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose Service"
        settingtextfildsUI()
        addSelectFloatingPannel()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateAdrress(address: address)
    }
    func settingtextfildsUI(){
        toLocation.leftViewMode = .always
        let ToImageView = UIImageView()
        ToImageView.image = UIImage(systemName: "pin")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        toLocation.leftView = ToImageView
        toLocation.borderStyle = .roundedRect
        
        fromLocation.leftViewMode = .always
        let fromImageView = UIImageView()
        fromImageView.image = UIImage(systemName: "location")
        fromLocation.leftView = fromImageView
        fromLocation.borderStyle = .roundedRect
    }
    
    @IBAction func selectPlaceOnMap(_ sender: Any) {
        addresstypeToRecieve = .pickupLocation
        if toLocation.isFirstResponder {
            addresstypeToRecieve = .destinationLocation
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    func addSelectFloatingPannel(){
        floatingPanelController.layout = DriverFloatingPanelLayout()
        floatingPanelController.set(contentViewController: ServiceViewController())
        floatingPanelController.isRemovalInteractionEnabled = true
        floatingPanelController.addPanel(toParent: self)
    }
}

class DriverFloatingPanelLayout: FloatingPanelLayout{
    var position: FloatingPanelPosition = .bottom
    
    var initialState: FloatingPanelState = .half
    
    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring]{
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.44, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
