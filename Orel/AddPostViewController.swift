//
//  AddPostViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 3/3/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse


class AddPostViewController: UIViewController {
    
    @IBOutlet weak var addPostTitle: UITextField!
    @IBOutlet weak var addPostContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blurback1.jpg")!)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        if(addPostTitle.text != "" && addPostContent.text != ""){
        var post = PFObject(className:"Posts")
        post["p_title"] = addPostTitle.text
        post["p_content"] = addPostContent.text
        post["p_user"] = PFUser.current()
        post.saveInBackground {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
            
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
