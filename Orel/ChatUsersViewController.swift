//
//  ChatUsersViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 4/10/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse

var userName = "";

class ChatUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var resultsTable: UITableView!
    
    var resultsUsernameArray = [String]() //get the usernames
    var resultsImageFiles = [PFFile]() //get the user images
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theWeight = view.frame.size.width
        let theHeight = view.frame.size.height

        resultsTable.frame = CGRect(x: 0, y: 0, width: theHeight, height: theHeight-64)
        
        resultsTable.backgroundView = UIImageView(image: UIImage(named: "blurback.jpg"))
        resultsTable.tableFooterView = UIView()


        
        userName = (PFUser.current()?.username)!
        print(userName)

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        resultsUsernameArray.removeAll(keepingCapacity: false)
        resultsImageFiles.removeAll(keepingCapacity: false)
        
        let predicate = NSPredicate(format: "username != '"+userName+"'")
        let query = PFQuery(className: "_User", predicate: predicate)
        let objects = try! query.findObjects()  //UPDATE THIS
        
        //let objects = objects! as [PFObject]
        for object in objects {  //UPDATE THIS
            
            let us:PFUser = object as! PFUser //UPDATE THIS ADD IT
            self.resultsUsernameArray.append(us.username!)   //UPDATE THIS
            self.resultsImageFiles.append(object["imageFile"] as! PFFile)
            
            self.resultsTable.reloadData()
            
            
        }
        
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ChatUsersTableViewCell
        
        //otherName = cell.usernameLbl.text!
        otherProfileName = cell.profileNameLabel.text!
        self.performSegue(withIdentifier: "chat", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsUsernameArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ChatUsersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "chatUsersCell") as! ChatUsersTableViewCell
        
        cell.profileNameLabel.text = self.resultsUsernameArray[(indexPath as NSIndexPath).row]
        
        resultsImageFiles[(indexPath as NSIndexPath).row].getDataInBackground {
            (imageData: Data?, error:NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.profileImg.image = image
                
            }
        }

        
        return cell
        
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
