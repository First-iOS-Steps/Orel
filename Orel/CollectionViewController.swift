//
//  CollectionViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 4/30/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
 {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageArray = [UIImage(named: "people")] { didSet{ DispatchQueue.main.async { self.collectionView.reloadData() } } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Gallery"
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        collectionView.backgroundView = UIImageView(image: UIImage(named: "blurback.jpg"))
        
        
        //back button
        self.navigationController? .setNavigationBarHidden(false, animated:true)
        let backButton = UIButton(type: UIButtonType.custom)
        backButton.addTarget(self, action: #selector(CollectionViewController.methodCall(_:)), for: UIControlEvents.touchUpInside)
        backButton.setTitle("Profile", for: UIControlState())
        backButton.sizeToFit()
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem

        // Do any additional setup after loading the view.
    }
    
    func methodCall(_ sender:UIBarButtonItem){
        self.navigationController!.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView?.image = self.imageArray[(indexPath as NSIndexPath).row]
        //cell.titleLabel?.text = self.appleProducts[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "showImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showImage"
        {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as IndexPath
            let vc = segue.destination as! NewViewController
            vc.image = self.imageArray[(indexPath as NSIndexPath).row]!
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
            
            
                        imageArray.append(image)
            collectionView.reloadData()
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
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
