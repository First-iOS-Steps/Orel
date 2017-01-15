//
//  ProfileViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 2/13/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse

var friendsArray = [String]()
var changingImage: UIImage!

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var reveal: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Profile"
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.alpha = 0.0
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blurback.jpg")!)

        reveal.target = self.revealViewController()
        reveal.action = #selector(SWRevealViewController.revealToggle(_:))
        
        profileName.text = nameLabel.text
        
        profileImage.layer.cornerRadius = profileImage.bounds.size.width / 2.0
        profileImage.layer.borderWidth = 4
        profileImage.layer.borderColor = UIColor.orange.cgColor
        profileImage.clipsToBounds = true
    

        if (friendsArray.count == 0){
      displayUsers()
            getProfilePhoto()
        }
       
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if changingImage != nil {
        setProfilePhoto(changingImage)
        }
 
    }

    
    func displayUsers() {
        
        let query = PFUser.query()
        query!.whereKey("username", notEqualTo: profileName.text!)
        
        query!.findObjectsInBackground {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) users.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.object(forKey: "username")!)
                        friendsArray.append(object.object(forKey: "username")! as! String)
                        print(friendsArray)
                        
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func getProfilePhoto(){
        
        if (PFUser.current()?.object(forKey: "imageFile") != nil){
            let userImageFile: PFFile = PFUser.current()?.object(forKey: "imageFile") as! PFFile
            
            userImageFile.getDataInBackground (block: {
                (imageData: Data?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        
                        self.profileImage.image = UIImage(data:imageData)
                        
                        var image = self.profileImage.image
                        var size = CGSize(width: 120, height: 120)
                        
                        self.profileImage.image = self.scaleUIImageToSize(image!, size: size)
                        self.profileImage.contentMode = .center
                        if (self.profileImage.bounds.size.width > image!.size.width && self.profileImage.bounds.size.height > image!.size.height) {
                            self.profileImage.contentMode = UIViewContentMode.scaleAspectFit;
                            
                            self.profileImage.image = image
                            
                            changingImage = image
                            
                        }

                        
                    }
                }
            })


        }
        
        
    }
    
 /*   func updateProfilePhoto(){
        if (profileImage.image != nil){
        let profileImageData = UIImagePNGRepresentation(profileImage.image!)
        
        if (profileImageData != nil){
            let profileFileObject = PFFile(data: profileImageData!)
            var user = PFObject(className:"UserPhoto")
            user.setObject(profileFileObject!, forKey: "imageFile")
            user.setObject(PFUser.currentUser()!, forKey: "i_user")
            user.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
            }
        }
        }
        
    }*/
    
    func updateProfilePhoto(_ image: UIImage){
        var query = PFQuery(className:"_User")
        query.getObjectInBackground(withId: (PFUser.current()?.objectId)!) {
            (_User: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else {
                print((PFUser.current()?.objectId)!)
                if (self.profileImage.image != nil){

                let profileImageData = UIImagePNGRepresentation(image)
                    
                
                if (profileImageData != nil){
                    let profileFileObject = PFFile(data: profileImageData!)
                    _User!["imageFile"] = profileFileObject
                    _User!.saveInBackground()
                    }
                }
            }
            
        }
        
    
        
    }
    
    func setProfilePhoto(_ image: UIImage){
        profileImage.image = image
    }

 


    
    @IBAction func profileBarButton(_ sender: AnyObject) {
        callActionSheet()
    }

    func callActionSheet(){
        
        let title = "Profile"
        let message = "Personalize your data"
        
        let optionOneText: String! = "Change your profile photo"
        let optionTwoText: String! = "Edit your name"
        
        
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        let actionOne = UIAlertAction(title: optionOneText!, style: .default){ ACTION in
           
            //var imagePicker = UIImagePickerController()
            let sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            
            if UIImagePickerController.isSourceTypeAvailable(sourceType){
                self.imagePicker.sourceType = sourceType
                
                self.imagePicker.delegate = self
                
                
            self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        }
        
        let actionTwo = UIAlertAction(title: optionTwoText!, style: .default){ ACTION in
            
            //1. Create the alert controller.
            let alert = UIAlertController(title: "New Name", message: "Enter your text", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = ""
            })
            
            //3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                self.profileName.text = textField.text
                nameLabel.text = textField.text
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        
        actionSheet.addAction(actionOne)
        actionSheet.addAction(actionTwo)
        actionSheet.addAction(cancelAction)
        
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let size = CGSize(width: 120, height: 120)
        
        profileImage.image = scaleUIImageToSize(image, size: size)
        changingImage = scaleUIImageToSize(image, size: size)
        profileImage.contentMode = .center
        if (profileImage.bounds.size.width > image.size.width && profileImage.bounds.size.height > image.size.height) {
            profileImage.contentMode = UIViewContentMode.scaleAspectFit;
            
            profileImage.image = image
           
      
            
            
            
            
            
        }
        
       updateProfilePhoto(changingImage)
        dismiss(animated: true, completion: nil)

    
    }
    
    func scaleUIImageToSize(_ image: UIImage, size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
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
