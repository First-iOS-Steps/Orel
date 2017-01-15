//
//  GalleryCollectionViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 4/30/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse


class GalleryCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var resultsImageFiles = [PFFile]() //get the user images
    
    let imageArray = [UIImage(named: "friends")]


    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "blurback.jpg")!)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        //retreivePhotos()

    }
    
    
    func retreivePhotos(){
        
        resultsImageFiles.removeAll(keepingCapacity: true)
        //let user = (PFUser.currentUser()?.username)!
        
        
        //let predicate = NSPredicate(format: "g_user != '"+user+"'")
        let query = PFQuery(className: "Gallery")
        let objects = try! query.findObjects()  //UPDATE THIS
        
        //let objects = objects! as [PFObject]
        for object in objects {  //UPDATE THIS
            
            self.resultsImageFiles.append(object["g_photo"] as! PFFile)
            print(resultsImageFiles.count)
            
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gCell", for: indexPath) as! GalleryCell
    
        // Configure the cell
        
       /* resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData: NSData?, error:NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.ImageCell.image = image
                
            }
        }*/

        cell.ImageCell.image = self.imageArray[(indexPath as NSIndexPath).row]

    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showImage", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage"{
            let indexPaths = self.collectionView?.indexPathsForSelectedItems
            let indexPath = indexPaths![0] as IndexPath
            
            let vc = segue.destination as! FullSizeImage
            
            resultsImageFiles[(indexPath as NSIndexPath).row].getDataInBackground {
                (imageData: Data?, error:NSError?) -> Void in
                
                if error == nil {
                    
                    let image = UIImage(data: imageData!)
                    vc.image = image!
                    
                }
            }

            
        }
    }
    
    
    @IBAction func fromCamera(_ sender: AnyObject) {
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            //load the camera interface
            let picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        }else{
            //no camera available
            let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(alertAction)in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }

    }
    @IBAction func fromFolder(_ sender: AnyObject) {
        
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image: UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            
            let imageData = UIImagePNGRepresentation(image)
            let gallery = PFObject(className:"Gallery")
            let photoFileObject = PFFile(data: imageData!)
            
            gallery["g_photo"] = photoFileObject
            gallery["g_user"] = PFUser.current()?.username
            gallery.saveInBackground {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    //self.collectionView!.reloadData()
                } else {
                    // There was a problem, check error.description
                }
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
