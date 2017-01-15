//
//  UserProfileViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 4/30/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var pName: UILabel!
    
    @IBOutlet weak var pTable: UITableView!
    @IBOutlet weak var pLocation: UILabel!
    @IBOutlet weak var pPosition: UILabel!
    
    var posts = [Posts]() { didSet{ DispatchQueue.main.async { self.pTable.reloadData() } } }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Profile"
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.alpha = 0.0
        
        self.view.backgroundColor = UIColorFromRGB(0x2c3e50)    
        
        pImage.layer.cornerRadius = pImage.bounds.size.width / 4
        pImage.layer.borderWidth = 4
        pImage.layer.borderColor = UIColorFromRGB(0xc0392b).cgColor //#27ae60
        pImage.clipsToBounds = true
        
        pName.text = "Akri Cipa"
        retreivePosts() 

        pTable.backgroundColor = UIColorFromRGB(0x2c3e50)  

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.pTable.dequeueReusableCell(withIdentifier: "uCell", for: indexPath) 
        
        var post: Posts
        
        post = posts[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = post.title_line
        cell.textLabel?.numberOfLines = 0

        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.textColor = UIColor.white
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    


    func retreivePosts(){

        
        var query = PFQuery(className:"Posts")
        query.whereKey("p_user", notEqualTo: PFUser.current()!)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) posts.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        self.posts += [Posts(title_line: object.value(forKey: "p_content")! as! String)]
                        //postsArray.append(object.valueForKey("p_title")! as! String)
                        // print(postsArray)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.pTable.reloadData()
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
