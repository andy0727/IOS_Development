//
//  TweetKindTableViewCell.swift
//  Assignment4 SmashTag
//
//  Created by Andy Zhu on 8/27/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class TweetKindTableViewCell: UITableViewCell {
    var tweetKind: TweetKind? {
        didSet{updateUI()}
    }
    
    func updateUI(){
        
        if let kind = tweetKind{
            switch kind.content
            {
            case contentType.image(let media) :
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { [unowned self] () -> Void in
                    if let imageUrl = media.url, imageData = NSData(contentsOfURL: imageUrl){
                        // blocks main thread!
                        dispatch_async(dispatch_get_main_queue()){  () -> Void in
                            if self.contentView.subviews.count == 0 {
                                var sub = UIImageView()
                                sub.image = UIImage(data: imageData)
                                sub.contentMode = UIViewContentMode.ScaleAspectFit
                                sub.frame = CGRect(origin: self.contentView.frame.origin
                                    , size: self.frame.size)
                                
                                
                                self.contentView.addSubview(sub)
                            }
                        }
                    }
                }
            case contentType.user(let user):
                textLabel?.text = user.name
                
            case contentType.url(let url):
                textLabel?.text = url.keyword
                
                
            case contentType.hashTag(let tag):
                textLabel?.text = tag.keyword
                
            case contentType.userMention(let userMetion):
                textLabel?.text = userMetion.keyword
            }
            

        }
        
    }
    
    
    
    
}
