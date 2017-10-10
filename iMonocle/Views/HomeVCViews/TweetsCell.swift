//
//  TweetsCell.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 8/29/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import Alamofire

class TweetsCell: UICollectionViewCell {
    
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postMedia: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet var mediaImageVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet var mediaImageViewHieght: NSLayoutConstraint!
    
    
    var indexPath = [IndexPath]()
    var delegate: HomeVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        
    }
    
    // TO DO: Needs fixing
    
    func setUp(tweet: Tweet) {
        
        self.postMedia.isHidden = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true

        profileImage.downloadFrom(url: tweet.authorProfilePic! as URL)
        nameLabel.text = tweet.author
        userNameLabel.text = "@" + tweet.screenName!
        tweetContentLabel.text = tweet.text
        
        var urls = tweet.urls
        var media = tweet.media {
            didSet {
                
            }
        }
        
        var displayURLS = [String]()
        //postMedia.image = nil
        
        if let urls = urls {
            for _url in urls {
                let urlText = _url["url"] as! String
                tweetContentLabel.text = tweetContentLabel.text?.replacingOccurrences(of: urlText, with: "")
                
                var displayURL = _url["display_url"] as! String
                if let expancedURL = _url["expanded_url"] {
                    displayURL = expancedURL as! String
                }
                displayURLS.append(displayURL)
            }
            
        }
        
            
        if let media = media {
            for medium in media {
                let urlText = medium["url"] as! String
                self.tweetContentLabel.text = self.tweetContentLabel.text?.replacingOccurrences(of: urlText, with: "")
                if((medium["type"] as? String) == "photo") {
                    
                    let mediaurl = medium["media_url_https"] as! String
                    self.mediaImageViewHieght.isActive = false
                    self.postMedia.sizeToFit()
                    self.postMedia.layer.cornerRadius = 5
                    self.postMedia.clipsToBounds = true
                    self.displayPhoto(withMediaUrl: mediaurl)
                    self.delegate?.mainCollectionView.reloadItems(at: indexPath)
                }
            }
        } else {
            self.postMedia.isHidden = true
            self.mediaImageViewHieght.isActive = true
        }
        if displayURLS.count > 0 {
            
            let content = tweetContentLabel.text ?? ""
            let urlText = "\n" + displayURLS.joined(separator: "")
            let text = NSMutableAttributedString(string: content)
            let links = NSMutableAttributedString(string: urlText)
            links.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 36/255.0, green: 144/255.0, blue: 212/255.0, alpha: 1), range: NSRange(location: 0, length: urlText.characters.count))
            text.append(links)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            style.lineBreakMode = .byCharWrapping
            text.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: text.string.characters.count))
            tweetContentLabel.attributedText = text
        }
    }
    
    func displayPhoto(withMediaUrl: String) {
        self.postMedia.downloadedFrom(link: withMediaUrl)
        self.postMedia.isHidden = false
        self.mediaImageVerticalSpacingConstraint.constant = 8
    }
    
    @IBAction func retweetButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func commentsButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func likesButtonTapped(_ sender: Any) {
        
    }
    
}
