//
//  ServiceViewController.swift
//  FindDriver
//
//  Created by Rain Moustfa on 27/08/2022.
//

import UIKit

class ServiceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: CarTypeCellViewTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CarTypeCellViewTableViewCell.reuseIdentifier)
            tableView.register(UINib(nibName: ButtonsTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ButtonsTableViewCell.reuseIdentifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ServiceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension ServiceViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < 2 ){
            let selectorsCell = tableView.dequeueReusableCell(withIdentifier: CarTypeCellViewTableViewCell.reuseIdentifier) as! CarTypeCellViewTableViewCell
            selectorsCell.configCell(selection: getDemoEntities()[indexPath.row],parentView: self.view)
            return selectorsCell
        }
        else{
            let buttonsCell = tableView.dequeueReusableCell(withIdentifier: ButtonsTableViewCell.reuseIdentifier) as! ButtonsTableViewCell
            return buttonsCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}
