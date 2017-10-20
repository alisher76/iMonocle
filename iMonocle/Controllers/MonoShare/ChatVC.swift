//
//  ChatVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/21/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var dissMissBtn: UIButton!
    @IBOutlet weak var topImageView: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var selectedUser: MonocleShareUser? {
        didSet {
            
        }
    }
    
    var messages = [Message]() {
        didSet {
           tableView.reloadData()
        }
    }
    
    var messageDictionary = [String : Message]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.bindToKeyboard()
        
        textField.delegate = self
        
        let gestureRescognizer = UITapGestureRecognizer()
        gestureRescognizer.addTarget(self, action: #selector(ChatVC.dismissKeyboard))
        view.addGestureRecognizer(gestureRescognizer)
        
    }

    @IBAction func dismissBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        if textField.text != "" {
            sendBtn.isEnabled = true
            MonoShareDataService.instance.sendMessage(message: textField.text!, uid: (selectedUser?.id)!, sendComplete: { (success) in
                if success {
                    self.textField.text = ""
                    MonoShareDataService.instance.getAllMessages(handler: { (message) in
                     self.messageDictionary = message
                     self.messages = Array(self.messageDictionary.values)
                    })
                }
            })
        } else {
            sendBtn.isEnabled = false
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as? ChatVCCell else {
            return UITableViewCell()
        }
        cell.messageLabel.text = messages[indexPath.row].content
        cell.nameLabel.text = messages[indexPath.row].senderId
        return cell
    }
}

class ChatVCCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: CircleImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

