//
//  PostController.swift
//  Post-1.2
//
//  Created by Eva Marie Bresciano on 6/2/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation

class PostController {
    
    weak var delegate: PostControllerDelegate?
    
    init() {
        
        fetchPosts()
    }
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com/posts/")
    
    static let endpoint = baseURL?.URLByAppendingPathExtension("/posts.json")
    
    var posts: [Post] = []
    
    func fetchPosts(reset reset: Bool = true, completion: ((posts: [Post]) -> Void)? = nil) {
        guard let url = PostController.endpoint else {fatalError("URL optional is nil")}
        
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
            if let data = data,
                responseDataString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                guard let responseDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String:AnyObject],
                    postDictionaries = responseDictionary["posts"] as? [[String:AnyObject]] else {
                        print("Unable to serialize JSON. \nResponse: \(responseDataString)")
                        completion?(posts: [])
                        return
                }
                let posts = postDictionaries.flatMap{Post(JSONDictionary:$0)}
                completion?(posts: posts)
                
                let postsSorted = posts.sort({$0.0.timeStamp > $0.1.timeStamp})
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if reset {
                        self.posts = postsSorted
                    } else {
                        self.posts.appendContentsOf(postsSorted)
                    }
                    if let completion = completion {
                        completion(posts:postsSorted)
                    }
                    return
                })
            }
        }
    }
    
    func addPost(userName: String, text: String){
        let post = Post(userName: userName, text: text)
        guard let requestURL = post.endpoint else { fatalError("URL is nil")}
        
        NetworkController.performRequestForURL(requestURL, httpMethod: .Put, urlParameters: nil, body: post.jsonData, completion: { (data, error) in
            
            let responseDataString = NSString(data: data!, encoding: NSUTF8StringEncoding) ?? ""
            
            if error != nil {
                print("There was an error posting in \(#file) \(#function)")
            }
            self.fetchPosts()
        })
        
    }
}

protocol PostControllerDelegate: class {
    func postsUpdated(posts: [Post])
    
}
