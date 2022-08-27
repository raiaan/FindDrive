//
//  CarTypeCellViewTableViewCell.swift
//  FindDriver
//
//  Created by Rain Moustfa on 27/08/2022.
//

import UIKit

class CarTypeCellViewTableViewCell: UITableViewCell {
    let tableItems:UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    let transparentView = UIView()
    @IBOutlet weak var rightText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var button: UIButton!
    var selectionsItems:[String] = []{
        didSet{
            tableItems.reloadData()
        }
    }
    static var reuseIdentifier:String {
        return "CarTypeCellViewTableViewCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func showSelections(_ sender: Any) {
        addTransparentView(frames: button.frame)
    }
    func configCell(selection:SelectionService){
        tableItems.isHidden = true
        tableItems.dataSource = self
        tableItems.delegate = self
        icon.image = UIImage(systemName: selection.icon)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let lineView = UIView(frame: CGRect(x: -5 , y: 0 , width: 1, height: button.bounds.height))
        lineView.backgroundColor = .gray
        rightText.addSubview(lineView)
        button.titleLabel?.text = selection.data[0]
        rightText.text = selection.rightText
        selectionsItems = selection.data
    }
    
    
}
extension CarTypeCellViewTableViewCell:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        button.setTitle(selectionsItems[indexPath.row], for: .normal)
        removeTransparentView()
    }
}
extension CarTypeCellViewTableViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectionsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.textLabel?.text = selectionsItems[indexPath.row]
        return cell
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.frame;
        transparentView.addSubview(tableItems)
        self.contentView.addSubview(transparentView)
        tableItems.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
       // self.addSubview(tableItems)
        tableItems.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableItems.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.selectionsItems.count * 50))
        }, completion: nil)
    }
    @objc func removeTransparentView() {
        let frames = self.contentView.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableItems.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
}
