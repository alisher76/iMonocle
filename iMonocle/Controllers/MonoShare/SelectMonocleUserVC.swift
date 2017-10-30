//
//  SelectMonocleUserVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/24/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

protocol DidSelectUserDelegate {
    func returnPickedUser(selected: MonocleShareUser)
}

class SelectMonocleUserVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: InsetTextField!
    @IBOutlet weak var tableView: UITableView!
    
    var selectionDelegate: DidSelectUserDelegate!
    
    var friends = [MonocleShareUser]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let gestureRescognizer = UITapGestureRecognizer()
        gestureRescognizer.addTarget(self, action: #selector(SelectMonocleUserVC.tapToClose(_:)))
        backgroundView.addGestureRecognizer(gestureRescognizer)
        
        MonoShareDataService.instance.getAllUsers { (_friends) in
        self.friends = _friends
        }
    }


    @objc func tapToClose(_ gestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}


extension SelectMonocleUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as? SelectFriendCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = friends[indexPath.row].name
        cell.userNameLabel.text = friends[indexPath.row].email
        cell.profileImageView.downloadedFrom(link: friends[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TO DO Pick a user to send message to
        selectionDelegate.returnPickedUser(selected: friends[indexPath.row])
    }
}

class SelectFriendCell: UITableViewCell {
    
    // Mark: Outlets
    @IBOutlet weak var profileImageView: CircleImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    override func prepareForReuse() {
        
    }
}
