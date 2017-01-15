//
//  DetailTripViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 3/8/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class DetailTripViewController: UIViewController {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var returnLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    var fromValue: String!
    var toValue: String!
    var departureValue: String!
    var returnValue: String!
    var priceValue: String!
    var userValue: String!
    var daysLeftValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Trip Details"
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
        fromLabel.text = fromValue
        toLabel.text = toValue
        departureLabel.text = departureValue
        returnLabel.text = returnValue
        priceLabel.text = priceValue
        userLabel.text = userValue
        daysLeftLabel.text = daysLeftValue

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
