//
//  FriendsViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 2/16/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse



class FriendsViewController: UITableViewController, UISearchResultsUpdating {

    @IBOutlet weak var reveal: UIBarButtonItem!
    
    var friends = [Friends]()
    var filteredArray = [String]()
    
    var resultSearchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Friends"
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "blurback.jpg"))
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.barTintColor = UIColor.black
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.reloadData()
        print("friends")
        
        reveal.target = self.revealViewController()
        reveal.action = #selector(SWRevealViewController.revealToggle(_:))

        loadFriends()
        
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if self.resultSearchController.isActive {
            return self.filteredArray.count
        }else{
        return friends.count
    }
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) 
        
        var friend: Friends
        
        if self.resultSearchController.isActive{
            cell.textLabel?.text = filteredArray[(indexPath as NSIndexPath).row]
        }
        else{
            friend = friends[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = friend.title_line
        }
        
        
        return cell
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredArray.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let array = (friendsArray as NSArray).filtered(using: searchPredicate)
        
        self.filteredArray = array as! [String]
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        //let vc = UserProfileViewController  as UIViewController
           // self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    func loadFriends(){
        for i in friendsArray{
            self.friends += [Friends(title_line: i)]
        }
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
