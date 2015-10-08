//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Andy Zhu on 8/21/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    var tweet: Tweet? {
        didSet{ updateUI()}
    }

    @IBOutlet weak var TweetImageView: UIImageView!
    @IBOutlet weak var TweetScreenName: UILabel!
    @IBOutlet weak var TweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI(){
        
        //reset any existing information
        TweetScreenName?.text = nil
        TweetTextLabel?.attributedText = nil
        TweetImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        //load information from tweet if any
        if let tweet = self.tweet
        {
            
            var text = tweet.text
            for _ in tweet.media{
                text += " 📷"
            }
            let urlAttributes = [
                NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote),
                NSForegroundColorAttributeName : UIColor.blueColor()            ]
            let tagAttributes = [
                NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote),
                NSForegroundColorAttributeName : UIColor.redColor()
            ]
            let userAttributes = [
                NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote),
                NSForegroundColorAttributeName : UIColor.purpleColor()
            ]
            
            var attributedString = NSMutableAttributedString(string: text)
            
            for tag in tweet.hashtags{
                attributedString.addAttributes(tagAttributes, range: tag.nsrange)
            }
            
            for url in tweet.urls{
                attributedString.addAttributes(urlAttributes, range: url.nsrange)
            }
            for user in tweet.userMentions{
                attributedString.addAttributes(userAttributes, range: user.nsrange)
            }
            
            TweetTextLabel?.attributedText = attributedString
            
            
            
            TweetScreenName?.text = "\(tweet.user)" // tweet user description
            dispatch_async(dispatch_get_main_queue()){ () -> Void in
                if let profileImageUrl = tweet.user.profileImageURL, imageData = NSData(contentsOfURL: profileImageUrl){
                        // blocks main thread!
                        self.TweetImageView?.image = UIImage(data: imageData)
                    }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24 * 60 * 60{
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            }else{
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    
     }
    
}
