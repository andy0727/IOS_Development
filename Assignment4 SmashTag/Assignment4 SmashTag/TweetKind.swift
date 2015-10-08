//
//  TweetKind.swift
//  Assignment4 SmashTag
//
//  Created by Andy Zhu on 8/26/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import Foundation
import UIKit

enum contentType: Printable{
    case image(MediaItem)
    case user(User)
    case hashTag(Tweet.IndexedKeyword)
    case url(Tweet.IndexedKeyword)
    case userMention(Tweet.IndexedKeyword)
    
    var description: String {
        switch self{
        case .image: return "Image"
        case .user: return "User"
        case .hashTag: return "HashTag"
        case .url: return "Url"
        case .userMention: return "User Mentioned"
        }
    }
}

class TweetKind {

    var content: contentType
    
    init(image: MediaItem){
        content = .image(image)
    }
    
    init(user: User){
        content = .user(user)
    }
    
    init(tag: Tweet.IndexedKeyword){
        content = .hashTag(tag)
    }
    
    init(url: Tweet.IndexedKeyword){
        content = .url(url)
    }
    
    init(userMention: Tweet.IndexedKeyword){
        content = .userMention(userMention)
    }
}