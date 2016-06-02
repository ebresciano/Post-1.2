//
//  Post.swift
//  Post-1.2
//
//  Created by Eva Marie Bresciano on 6/2/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation

class Post {
    
    private let kUserName = "username"
    private let kText = "test"
    private let kTimeStamp = "timestamp"
    private let kIdentifier = "uuid"
    
    
    let userName: String
    let text: String
    let timeStamp: NSTimeInterval
    let indentifier: NSUUID
    
    init(userName: String, text: String, identifier: NSUUID = NSUUID()) {
        self.userName = userName
        self.text = text
        self.timeStamp = NSDate().timeIntervalSince1970
        self.indentifier = identifier
        
    }
    
    init?(JSONDictionary : [String:AnyObject]) {
        guard let userName = JSONDictionary[kUserName] as? String,
        text = JSONDictionary[kText] as? String,
        timeStamp = JSONDictionary[kTimeStamp] as? NSTimeInterval,
            identifier = JSONDictionary[kIdentifier] as? NSUUID else {
                return nil
        }
        self.userName = userName
        self.text = text
        self.timeStamp = NSDate().timeIntervalSince1970
        self.indentifier = identifier
    }

}
