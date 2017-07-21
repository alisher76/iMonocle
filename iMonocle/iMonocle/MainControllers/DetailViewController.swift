//
//  DetailViewController.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/19/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var imageName: String = "papass"
    var postImage: UIImage = UIImage()
    var postDescription: String = ""
    var postAuthorName: String = ""
    var numberOfComments: String = "100"
    var numberOfLikes: String = "87"
    var index: IndexPath?
    
    var isPresenting = true {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    @objc func actionClose(_ tap: UITapGestureRecognizer) {
        updateBeforeDismiss(indexPath: index!)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPresenting {
            return 2
        } else {
            return 1
        }
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        cell.profileImageView.image = postImage
        cell.postImageView.image = postImage
        cell.nameLabel.text = postAuthorName
        return cell
    } else {
        index = indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! DetailCell
        cell.descriptionLabel.text = postDescription
        cell.numberOfComments.text = numberOfComments
        cell.numberOfLikes.text = numberOfLikes
        return cell
    }
    
   }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return isPresenting ? 500 : 600
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            cell.alpha = 0
            UIView.animate(withDuration: 1.0) { cell.alpha = 1 }
        }
    }
    
    func updateBeforeDismiss(indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DetailCell
        UIView.animate(withDuration: 0.5) { cell.alpha = 0 }
        isPresenting = false
    }
}
