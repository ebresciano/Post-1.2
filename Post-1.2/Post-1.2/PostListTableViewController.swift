//
//  PostListTableViewController.swift
//  Post-1.2
//
//  Created by Eva Marie Bresciano on 6/2/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, PostControllerDelegate {
    
    let postController = PostController()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        var refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl

            }
    
    func postsUpdated(posts: [Post]) {
        tableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        tableView.reloadData()
    }
    
    func presentNewPostAlert() {
        let alertController = UIAlertController(title: "New post", message: nil, preferredStyle: .Alert)
        
        var usernameTextField: UITextField?
        var messageTextField: UITextField?
        
        let postAction = UIAlertAction(title: "Post", style: .Default) { (action) in
            //post post
            guard let username = usernameTextField?.text where !username.isEmpty,
                let text = messageTextField?.text where !text.isEmpty else {
                    
                    self.presentErrorAlert()
                    
                    return
            }
            self.postController.addPost(username, text: text)
        }
        
        alertController.addAction(postAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentErrorAlert() {
        let errorAlert = UIAlertController(title: "Error", message: "Missing information", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        errorAlert.addAction(cancelAction)
        
        presentViewController(errorAlert, animated: true, completion: nil)
    }
    
    


    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postController.posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(indexPath.row) \(post.userName) \(NSDate(timeIntervalSince1970: post.timeStamp))"
        
        return cell
    }
    
    //MARK - Actions
    
    @IBAction func plusButtonTapped(sender: UIBarButtonItem) {
        presentNewPostAlert()
        
    }
    
    @IBAction func refreshControlPulled(sender: UIRefreshControl) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        postController.fetchPosts(reset: true) { (newPosts) in
            sender.endRefreshing()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }

   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
