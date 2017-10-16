//
//  CreateChannelVC.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/22/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class CreateChannelVC: UIViewController {

    @IBOutlet weak var backgroundVIew: UIView!
    
    @IBOutlet weak var channelImagePickerView: CircleImage!
    @IBOutlet weak var channelNameTextField: InsetTextField!
    @IBOutlet weak var channelDescriptionTextField: InsetTextField!
    @IBOutlet weak var createBtn: RoundedButton!
    @IBOutlet weak var chooseIconBtn: UIButton!
    @IBOutlet var rondedView: RoundedUIView!
    
    var avatarName = "profileDefault"
    var delegate: MonocleShareVC!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRescognizer = UITapGestureRecognizer()
        gestureRescognizer.addTarget(self, action: #selector(CreateChannelVC.tapToClose(_:)))
        backgroundVIew.addGestureRecognizer(gestureRescognizer)
        view.bindToKeyboard()
    }
    
    @objc func tapToClose(_ gestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func chooseIconBtnTapped(_ sender: Any) {
      //pickAvatarVC
        print("worksFine")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let avatarVC = storyboard.instantiateViewController(withIdentifier: "pickAvatarVC") as! AvatarPickVC
        self.present(avatarVC, animated: true, completion: nil)
        
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        
        if channelNameTextField.text != "" && channelDescriptionTextField.text != "" {
            MonoShareDataService.instance.createChannel(withTitle: channelNameTextField.text!, withDiscription: channelDescriptionTextField.text!, channelImage: avatarName, handler: { (success) in
                if success {
                    print("SuccessFulltCreatedChannel")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("SomethingWentWrong")
                }
            })
        }
    }
}
