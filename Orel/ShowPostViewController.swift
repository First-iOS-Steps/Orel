//
//  ShowPostViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 3/3/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse

class ShowPostViewController: UIViewController {

    @IBOutlet weak var showPostTitle: UITextField!
    @IBOutlet weak var showPostContent: UITextView!
    var passedValue: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blurback1.jpg")!)

        print(passedValue)
        showPostTitle.text = passedValue
        
        var query = PFQuery(className:"Posts")
        query.whereKey("p_title", equalTo: passedValue)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) posts.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        self.showPostContent.text = object.value(forKey: "p_content") as! String
                        
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

        // Do any additional setup after loading the view.
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
