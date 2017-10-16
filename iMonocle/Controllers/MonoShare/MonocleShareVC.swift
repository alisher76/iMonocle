//
//  MonocleShareVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/20/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Firebase

enum MonoShareSegmentOptions {
    case channels, messages, groups, more
}

class MonocleShareVC: UIViewController {
    
    var channels = [Channel]()
    var groups = [Group]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBurgerBtn: UIButton!
    
    var messages = [Message]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedUser: MonocleShareUser? {
        didSet {
            goToSendMessageVC()
        }
    }

    var selectedSegmentOption: MonoShareSegmentOptions = .channels {
        didSet {
            checkDataBase()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBurgerBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        tableView.delegate = self
        tableView.dataSource = self
        
        checkDataBase()
        
    }
    @IBAction func channelsBtnTapped(_ sender: Any) {
        selectedSegmentOption = .channels
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        if selectedSegmentOption == .channels {
            let createChannelVC = CreateChannelVC()
            createChannelVC.delegate = self
            createChannelVC.modalPresentationStyle = .custom
            self.present(createChannelVC, animated: true, completion: nil)
        } else if selectedSegmentOption == .messages {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let selectFriendVC = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.selectFriendVC.rawValue) as! SelectMonocleUserVC
            selectFriendVC.modalPresentationStyle = .custom
            selectFriendVC.selectionDelegate = self
            self.present(selectFriendVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func messagesBtnTapped(_ sender: Any) {
        selectedSegmentOption = .messages
    }
    
    @IBAction func groupMessagesBtnTapped(_ sender: Any) {
        selectedSegmentOption = .groups
    }
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        selectedSegmentOption = .more
    }
    
    // MARK: CheckDataBase
    func checkDataBase() {
        if selectedSegmentOption == .channels {
            MonoShareDataService.instance.getAllChannels(handler: { (channels) in
                self.channels = channels
                self.tableView.reloadData()
            })
        } else if selectedSegmentOption == .messages {
            MonoShareDataService.instance.getAllMessages(handler: { (messages) in
                for (_, value) in messages {
                    self.messages.append(value)
                }
            })
        } else if selectedSegmentOption == .groups {
            FirebaseService.instance.REF_USERS.child(FirebaseService.instance.currentuserID!).child("messages").observe(.value, with: { (snapshot) in
                
            })
            
        } else {
            
        }
    }
}

extension MonocleShareVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegmentOption  {
        case .channels:
            return channels.count
        case .messages:
            return messages.count
        case .groups:
            return groups.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedSegmentOption {
        case .channels:
            guard let channelCell = tableView.dequeueReusableCell(withIdentifier: "channelCell") as? ChannelCell else { return UITableViewCell() }
            channelCell.setupCell(channel: channels[indexPath.row])
            return channelCell
        case .messages:
            guard let messagesCell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessagesCell else { return UITableViewCell() }
            messagesCell.setupCell(message: messages[indexPath.row])
            return messagesCell
        case .groups:
            guard let groupCell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupCell else { return UITableViewCell() }
            return groupCell
        case .more:
            return UITableViewCell()
        }
    }
    
    func goToSendMessageVC() {
        if selectedSegmentOption == .messages {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let chatVC = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.chatVC.rawValue) as! ChatVC
            chatVC.selectedUser = selectedUser!
            self.show(chatVC, sender: self)
        }
    }
}

extension MonocleShareVC: DidSelectUserDelegate {
    
    func returnPickedUser(selected: MonocleShareUser) {
        selectedUser = selected
    }
}
