//
//  MonoChatVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/20/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Firebase

enum MonoShareSegmentOptions {
    case channels, messages
}

class MonocleShareVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBurgerBtn: UIButton!
    
    // Variables
    var messages = [Message]()
    var channels = [Channel]()
    var groups = [Group]()
    var selectedChannel: Channel?
    var selectedMessage: Message?
    
    // Mark: Show particular VC based on a selected option
    var selectedUser: MonocleShareUser? {
        didSet {
            if selectedSegmentOption == .channels && selectedChannel != nil {
                self.goToSendMessageVC(id: (selectedChannel?.channelID)!)
            } else if selectedSegmentOption == .messages && selectedMessage != nil {
                self.goToSendMessageVC(id: (selectedMessage?.toId)!)
            }
        }
    }

    //Mark: Menu options
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
    
    // MARK: CheckDataBase
    func checkDataBase() {
        if selectedSegmentOption == .channels {
            MonoShareDataService.instance.getAllChannels(handler: { (channels) in
                self.channels = channels
                self.tableView.reloadData()
            })
        } else if selectedSegmentOption == .messages {
            MonoShareDataService.instance.getAllMessagess(gotMessages: { (messagesArray) in
                self.messages = messagesArray
                self.tableView.reloadData()
            })
            MonoShareDataService.instance.observeUserMessage()
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
            if self.messages.count != 0 {
                return messages.count
            } else {
                return 0
            }
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
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedSegmentOption {
        case .channels:
            self.selectedChannel = channels[indexPath.row]
//            self.goToSendMessageVC(id: selectedChannel)
        case .messages:
            self.selectedMessage = messages[indexPath.row]
//            self.goToSendMessageVC(id: self.selectedMessage?.toId)
        }
    }
    
    func goToSendMessageVC(id: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.chatVC.rawValue) as! ChatVC
        chatVC.selectedUser = selectedUser!
        if selectedSegmentOption == .messages {
            chatVC.userID = id
        } else {
            chatVC.channelID = id
        }
        self.show(chatVC, sender: self)
    }
}

extension MonocleShareVC: DidSelectUserDelegate {
    func returnPickedUser(selected: MonocleShareUser) {
        selectedUser = selected
    }
}
