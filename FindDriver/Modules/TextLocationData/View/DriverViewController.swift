//
//  DriverViewController.swift
//  FindDriver
//
//  Created by Rain Moustfa on 24/08/2022.
//

import UIKit
import FloatingPanel
import GooglePlaces

protocol DriverViewControllerType{
    var presenter : DriverPresenterType{set get}
}
enum AddressType{
    case pickupLocation
    case destinationLocation
}
class DriverViewController: UIViewController ,FloatingPanelControllerDelegate{
    
    @IBOutlet weak var PickuptLocationLabel: UILabel!
    @IBOutlet weak var predictionsTable: UITableView!
    @IBOutlet weak var toLocation: UITextField!
    @IBOutlet weak var fromLocation: UITextField!
    var floatingPanelController: FloatingPanelController = FloatingPanelController()
    var addresstypeToRecieve = AddressType.pickupLocation
    var fetcher: GMSAutocompleteFetcher?
    var predictions:[String] = []
    var address:String = ""
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?,address:String ) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.address = address
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverFacad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateAdrress(address: address)
    }
    
    @IBAction func selectPlaceOnMap(_ sender: Any) {
        addresstypeToRecieve = .pickupLocation
        if toLocation.isFirstResponder {
            addresstypeToRecieve = .destinationLocation
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

//mark extensions
extension DriverViewController{
    
    func driverFacad(){
        title = "Choose Service"
        settingtextfildsUI()
        addSelectFloatingPannel()
        configFetcher()
        configTable()
        configTextFields()
    }
    
    func addSelectFloatingPannel(){
        floatingPanelController.layout = DriverFloatingChild()
        floatingPanelController.set(contentViewController: ServiceViewController())
        floatingPanelController.isRemovalInteractionEnabled = true
        floatingPanelController.addPanel(toParent: self)
    }
    func configTextFields(){
        toLocation.delegate = self
        fromLocation.delegate = self
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
    
    func updateAdrress(address:String){
        switch addresstypeToRecieve {
        case .pickupLocation:
            fromLocation.text = address
        case .destinationLocation:
            toLocation.text = address
        }
    }
}

extension DriverViewController :GMSAutocompleteFetcherDelegate{
    func configFetcher(){
        // Set bounds to inner-west Sydney Australia.
           let neBoundsCorner = CLLocationCoordinate2D(latitude: 30.033333,longitude: 31.233334)
            let swBoundsCorner = CLLocationCoordinate2D(latitude: -33.875725,longitude: 151.200349)
            // Set up the autocomplete filter.
            let filter = GMSAutocompleteFilter()
            filter.locationRestriction = GMSPlaceRectangularLocationOption(neBoundsCorner, swBoundsCorner)

            // Create a new session token.
            let token: GMSAutocompleteSessionToken = GMSAutocompleteSessionToken.init()
            // Create the fetcher.
            fetcher = GMSAutocompleteFetcher(filter: filter)
            fetcher?.delegate = self
            fetcher?.provide(token)
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.predictions = predictions.map{ item in
            "\(item.attributedPrimaryText)"
        }
        print("returned\(predictions.count)")
        if self.predictions.count > 0{
            predictionsTable.reloadData()
            predictionsTable.isHidden = false
        }
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        predictions = []
        predictionsTable.reloadData()
        predictionsTable.isHidden = true
    }
}

extension DriverViewController : UITextFieldDelegate{

    func textFieldDidChangeSelection(_ textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
        print(textField.text)
        PickuptLocationLabel.text = fromLocation.text
    }
}

extension DriverViewController : UITableViewDelegate,UITableViewDataSource{
    func configTable(){
        predictionsTable.delegate = self
        predictionsTable.dataSource = self
        predictionsTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        predictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = predictions[indexPath.row]
        return cell
    }
    
    
}
