//
//  TweetCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 7/15/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit


class TweetCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaImageViewHeight: NSLayoutConstraint!
    
    var tweetTextFontSize: CGFloat { get { return 15.0 }}
    var tweetTextWeigth: CGFloat { get { return UIFont.Weight.regular.rawValue} }
    var delegate: HomeViewController?
    
    var tweet: Tweet? {
        didSet {
            setUp()
        }
    }
    
    func setUp() {
        
        let urls = tweet?.urls
        let media = tweet?.media
        
        profileImageView.downloadFrom(url: (tweet?.authorProfilePic)!)
        nameLabel.text = tweet?.author
        userNameLabel.text = tweet?.screenName
        descriptionLabel.text = tweet?.text
        
        var displayURLS = [String]()
        mediaImageView.image = nil
        if let urls = urls {
            for _url in urls {
                let urlText = _url["url"] as! String
                descriptionLabel.text = descriptionLabel.text?.replacingOccurrences(of: urlText, with: "")
                var displayURL = _url["display_url"] as! String
                if let expancedURL = _url["expanded_url"] {
                    displayURL = expancedURL as! String
                }
                displayURLS.append(displayURL)
            }
        }
        
        if displayURLS.count > 0 {
            
            
            let content = descriptionLabel.text ?? ""
            let urlText = "\n" + displayURLS.joined(separator: "")
            let text = NSMutableAttributedString(string: content)
            let links = NSMutableAttributedString(string: urlText)
            links.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 36/255.0, green: 144/255.0, blue: 212/255.0, alpha: 1), range: NSRange(location: 0, length: urlText.characters.count))
            text.append(links)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            style.lineBreakMode = .byCharWrapping
            text.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: text.string.characters.count))
            descriptionLabel.attributedText = text
        }
        
        if let media = media {
            for medium in media {
                
                let urltext = medium["url"] as! String
                self.descriptionLabel.text = self.descriptionLabel.text?.replacingOccurrences(of: urltext, with: "")
                if((medium["type"] as? String) == "photo") {
                    
                    let mediaUrl = medium["media_url_https"] as! String
                    self.mediaImageView.sizeToFit()
                    self.mediaImageView.layer.cornerRadius = 5
                    self.mediaImageView.clipsToBounds = true;
                    self.mediaImageView.downloadedFrom(link: mediaUrl)
                    self.delegate?.feedsCollectionView?.reloadData()
                }
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mediaImageViewHeight.isActive = false
        self.mediaImageView.sizeToFit()
        self.mediaImageView.layer.cornerRadius = 5
        self.mediaImageView.clipsToBounds = true
        
        self.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true;
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false;
    }
}
