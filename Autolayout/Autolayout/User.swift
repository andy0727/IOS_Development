//
//  User.swift
//  Autolayout
//
//  Created by Andy Zhu on 8/16/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import Foundation
struct  User {
    var name : String
    var company : String
    var login : String
    var psw : String
    
    static func login(username: String, password: String) -> User?{
        if let user = database[username] {
            if user.psw == password{
                return user
            }
        }
        return nil
    }
    
    static let database: [String : User] = {
        var thedatabase = [String : User]()
        for u in [
            User(name: "aaa", company: "apple", login: "aaa", psw: "111"),
            User(name: "bbb", company: "google", login: "bbb", psw: "111"),
            User(name: "ccc", company: "facebook", login: "ccc", psw: "111"),
            User(name: "ddd", company: "linkedIN", login: "ddd", psw: "111")]
        {thedatabase[u.login] = u}
        return thedatabase
    }()
}