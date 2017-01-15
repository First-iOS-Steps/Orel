//
//  UploadTicketViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 3/4/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse

class UploadTicketViewController: UIViewController {

    @IBOutlet weak var departureDate: UIDatePicker!
    
    @IBOutlet weak var arrivalDate: UIDatePicker!
    
    @IBOutlet weak var fromText: UITextField!
    
    @IBOutlet weak var toText: UITextField!
    
    @IBOutlet weak var priceText: UITextField!
    
    var departureString: String!
    var returnString: String!
    var from: String!
    var to: String!
    var price: Double!
    var error: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Upload a Ticket"
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blurback1.jpg")!)

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        departureString = dateFormatter.string(from: departureDate.date)
        returnString = dateFormatter.string(from: arrivalDate.date)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTicket(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }

    @IBAction func saveTicket(_ sender: AnyObject) {
 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dDate = dateFormatter.date(from: departureString!)
        let rDate = dateFormatter.date(from: returnString!)
        from = fromText.text
        to = toText.text
        price = Double(priceText.text!)

        
        let dateComparisionResult:ComparisonResult = dDate!.compare(rDate!)
        
        let decimalCharacters = CharacterSet.decimalDigits
        
        let fromDecimalRange = from.rangeOfCharacter(from: decimalCharacters, options: NSString.CompareOptions(), range: nil)
        let toDecimalRange = from.rangeOfCharacter(from: decimalCharacters, options: NSString.CompareOptions(), range: nil)
    
        
        if dateComparisionResult == ComparisonResult.orderedDescending
        {
            // Departure date is greater than end date.
            error = true
        } else if (from == "" || to == "" || price == nil) {
            error = true
        }
        else if (fromDecimalRange != nil || toDecimalRange != nil){
            error = true
        }else{
            error = false
        }

        
        print(error)
        
        if (error == false){
            
            var ticket = PFObject(className:"Ticket")
            ticket["departure"] = dDate
            ticket["return"] = rDate
            ticket["from"] = from
            ticket["to"] = to
            ticket["price"] = price
            ticket["t_user"] = PFUser.current()
            ticket.saveInBackground {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
            let alert = UIAlertController(title: "Success", message: "Ticket upload successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(alertAction)in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func departureDateChanged(_ sender: AnyObject) {
        setDepartureDate()
    }
    
    @IBAction func returnDateChanged(_ sender: AnyObject) {
        setReturnDate()
    }
    
    func setDepartureDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        departureString = dateFormatter.string(from: departureDate.date)
    }
    
    func setReturnDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        returnString = dateFormatter.string(from: arrivalDate.date)
        
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
