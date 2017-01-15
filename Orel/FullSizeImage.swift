//
//  FullSizeImage.swift
//  Orel
//
//  Created by Etjen Ymeraj on 4/30/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class FullSizeImage: UIViewController {
    @IBOutlet weak var fullSize: UIImageView!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        
        self.fullSize.image = self.image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
