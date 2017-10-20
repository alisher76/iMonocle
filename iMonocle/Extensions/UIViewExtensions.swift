//
//  UIViewExtensions.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/6/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

@IBDesignable
class Shadow: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 20.0 {
        didSet {
            self.layer.masksToBounds = false
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.layer.shadowRadius = 1
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
    }
}

extension UIView {
    
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
            
        },completion: {(true) in
            self.layoutIfNeeded()
        })
    }
}
