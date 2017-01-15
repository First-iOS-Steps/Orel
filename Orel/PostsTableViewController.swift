//
//  PostsTableViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 3/3/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse


class PostsTableViewController: UITableViewController {
    
    var posts = [Posts]() { didSet{ DispatchQueue.main.async { self.tableView.reloadData() } } }
    var postToDelete: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Posts"
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()

        
        retreivePosts()

        tableView.tableFooterView = UIView()
        self.refreshControl?.addTarget(self, action: #selector(PostsTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)

        tableView.backgroundView = UIImageView(image: UIImage(named: "blurback1.jpg"))
    
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func refresh(_ sender:AnyObject){
        var query1 = PFQuery(className: "Posts")
        query1.order(byDescending: "createdAt")
        query1.whereKey("p_user", equalTo: PFUser.current()!)
        query1.getFirstObjectInBackground {
            (objects: PFObject?, error: NSError?) -> Void in

          self.posts += [Posts(title_line: objects!["p_title"] as! String)]
 
        }
        
        tableView.reloadData()
        
        refreshControl?.endRefreshing()
    }
    
    @IBAction func done(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }

    @IBAction func addPost(_ sender: AnyObject) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) 

        var post: Posts
        
        post = posts[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = post.title_line
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell!
        postToDelete = currentCell?.textLabel?.text!
        
        var query = PFQuery(className:"Posts")
        query.whereKey("p_title", equalTo: postToDelete)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) posts.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        object.deleteInBackground()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        posts.remove(at: (indexPath as NSIndexPath).row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)

    }

    func retreivePosts(){
        var query = PFQuery(className:"Posts")
        query.whereKey("p_user", equalTo: PFUser.current()!)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) posts.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        self.posts += [Posts(title_line: object.value(forKey: "p_title")! as! String)]
                        //postsArray.append(object.valueForKey("p_title")! as! String)
                        // print(postsArray)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.tableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier! == "showPost" {
            let ShowPostVC = segue.destination as! ShowPostViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!
            ShowPostVC.passedValue = currentCell?.textLabel?.text!
        } else if segue.identifier! == "addPost"{
            var AddPostVC = segue.destination as! AddPostViewController
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
