//
//  TweetTableViewController.swift
//  
//
//  Created by Andy Zhu on 8/19/15.
//
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    //MARK: - Handles the searching field
    
    var Tweets = [[Tweet]]()
    
    var searchText: String? = "#standford"{
        didSet{
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText
            Tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }

    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension   //calculate the rou height
        refresh()
        
    }
    
    
    // MARK: - refreshing tweets
    var lastSuccessfulRequest: TwitterRequest?
    var nextRequest: TwitterRequest? {
        if lastSuccessfulRequest == nil{
            if searchText != nil{
                return TwitterRequest(search: searchText!, count: 100)
            }else
            {
                return nil
            }
        }else{
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    func refresh(){
        if refreshControl != nil{
            refreshControl?.beginRefreshing()
        }
        refreshControl(refreshControl)
    }
    
    @IBAction func refreshControl(sender: UIRefreshControl? ) {
        if let request = nextRequest
        {
            request.fetchTweets { (newTweets) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newTweets.count > 0{
                        self.lastSuccessfulRequest = request
                        self.Tweets.insert(newTweets, atIndex: 0)
                        self.tableView.reloadData()
                    }
                    sender?.endRefreshing()
                }
            }
    
        }else{
            sender?.endRefreshing()
        }
    }
    
    // MARK: - Storyboard Connectivity
    
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    private struct StoryBoard{
        static let cellReuseIdentifier = "Tweet"
    }
    
    
    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return Tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Tweets[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.cellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell

        // Configure the cell...
        cell.tweet = Tweets[indexPath.section][indexPath.row]
        return cell
    }
    
    
    //Mark: - Start of My code for Assignment 4
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let id = segue.identifier{
            switch id{
            case "ShowTweet":
                if let tdc = segue.destinationViewController as? TweetDetailTableViewController{
                    if let cell = sender as? TweetTableViewCell{
                        if let tweet = cell.tweet{
                            
                            tdc.contents.append([TweetKind(user: tweet.user)])
                            
                            var userMentions = [TweetKind] ()
                            for user in tweet.userMentions{
                                userMentions.append(TweetKind(userMention: user))
                            }
                            if !userMentions.isEmpty{
                            tdc.contents.append(userMentions)
                            }
                            
                            var tags = [TweetKind] ()
                            for tag in tweet.hashtags{
                                tags.append(TweetKind(tag: tag))
                            }
                            if !tags.isEmpty{
                            tdc.contents.append(tags)
                            }
                            
                            var urls = [TweetKind] ()
                            for url in tweet.urls{
                                urls.append(TweetKind(url: url))
                            }
                            if !urls.isEmpty{
                            tdc.contents.append(urls)
                            }
                            
                            var medias = [TweetKind]()
                            for media in tweet.media{
                                medias.append(TweetKind(image: media))
                            }
                            if !medias.isEmpty{
                                tdc.contents.append(medias)
                            }

                        }
                    }
                }
                
                
            default: break
            }
        }
    }
    
    


}
