//
//  TweetDetailTableViewController.swift
//  Assignment4 SmashTag
//
//  Created by Andy Zhu on 8/26/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {

    var contents = [[TweetKind]] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension   //calculate the rou height
        navigationController?.navigationBar.translucent = true
    }

    // MARK: - storyboard connectivity
    private struct StoryBoard{
        static let cellReuseIdentifier = "TweetKind"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return contents.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return contents[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.cellReuseIdentifier, forIndexPath: indexPath) as! TweetKindTableViewCell

        // Configure the cell...
        cell.tweetKind = contents[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var title = self.tableView(tableView, viewForHeaderInSection: 0)
        return title?.bounds.height ?? 0
    }

    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // define the section header 
        var header = UILabel()
        header.text = "\(contents[section][0].content)"
        header.sizeToFit()
        return header
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch contents[indexPath.section][indexPath.row].content {
        case .image:
            return tableView.frame.width
        default: return tableView.rowHeight
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = contents[indexPath.section][indexPath.row]
        println("i have been clicked indicator")
        switch cell.content{
        case .hashTag: fallthrough
        case .userMention: fallthrough
        case .user:
            performSegueWithIdentifier("SearchTweet", sender: cell)
        case .image:
            performSegueWithIdentifier("ShowImage", sender: cell)
        case .url(let url):
            println(" url has be choosen")
            UIApplication.sharedApplication().openURL(NSURL(string: url.keyword)!)
        }
        
        
    }
    
    // MARK: -handling segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier{
            switch id{
            case "SearchTweet":
                if let tvc = segue.destinationViewController as? TweetTableViewController,
                    cell = sender as? TweetKind
                {
                    switch cell.content{
                    case .hashTag(let tag): tvc.searchText = tag.keyword
                    case .userMention(let userMention): tvc.searchText = userMention.keyword
                    case .user(let user): tvc.searchText = user.screenName
                    default: break
                    }
                }
            case "ShowImage":
                if let ivc = segue.destinationViewController as? ImageViewController,
                    cell = sender as? TweetKind
                {
                    switch cell.content{
                    case .image(let image): ivc.url = image.url
                    default: break
                    }
                }
            default: break
            }
        }
    }
}



/*
// Override to support conditional editing of the table view.
override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
// Return NO if you do not want the specified item to be editable.
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
// Return NO if you do not want the item to be re-orderable.
return true
}
*/
