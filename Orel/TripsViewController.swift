//
//  TripsViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 2/16/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse

class TripsViewController: UITableViewController {

    @IBOutlet weak var reveal: UIBarButtonItem!
    
    let date = Date()
    
    var trips = [Trips]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Trips"
        bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        tableView.backgroundView = UIImageView(image: UIImage(named: "blurback.jpg"))
        
        reveal.target = self.revealViewController()
        reveal.action = #selector(SWRevealViewController.revealToggle(_:))

        tableView.tableFooterView = UIView()
        
        retreiveTrips()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func retreiveTrips(){
        var query = PFQuery(className:"Ticket")
        query.includeKey("t_user")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) posts.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                        var user = object["t_user"] as! PFObject
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yy"
                        print(object.objectId)
                        print(object.value(forKey: "price"))
                        print(object.value(forKey: "t_user")!.objectId)
                        self.trips += [Trips(departureLabel: dateFormatter.string(from: object["departure"] as! Date), returnLabel: dateFormatter.string(from: object["return"] as! Date),fromLabel: object.value(forKey: "from")! as! String, toLabel: object.value(forKey: "to") as! String, priceLabel: object.value(forKey: "price") as! Double, userLabel: user["username"] as! String)]
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.tableView.reloadData()
        }
        
    }
    
    func getCurrentDate() -> String {
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        
        print("\(day)/\(month)/\(year)")
        return("\(day)/\(month)/\(year)")
    }
    
    func daysLeft(_ departureDate: String) ->  Int{
        let calendar: Calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let firstDate = dateFormatter.date(from: getCurrentDate())
        let secondDate = dateFormatter.date(from: departureDate)
        
        let date1 = calendar.startOfDay(for: firstDate!)
        let date2 = calendar.startOfDay(for: secondDate!)
        
        let flags = NSCalendar.Unit.day
        let components = (calendar as NSCalendar).components(flags, from: firstDate!, to: secondDate!, options: [])
        
        print(components.day)
        if components.day! >= 0{
            return components.day!}
        else{
            return 0}
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.trips.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! SingleTicketTableViewCell

        
        
        var trip: Trips
        
        trip = trips[(indexPath as NSIndexPath).row]

        cell.fromLabel.text = trip.fromLabel
        cell.departureLabel.text = trip.departureLabel
        cell.toLabel.text = trip.toLabel
        cell.returnLabel.text = trip.returnLabel
        
        cell.priceLabel = trip.priceLabel
        cell.userLabel  = trip.userLabel
    
        cell.coverImage = UIImageView(image: UIImage(named: "cover.jpg"))
        cell.blurImage = UIImageView(image: UIImage(named: "airplane.png"))

        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
            let DetailTripVC = segue.destination as! DetailTripViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRow(at: indexPath!) as! SingleTicketTableViewCell!
            DetailTripVC.fromValue = currentCell?.fromLabel.text
            DetailTripVC.toValue = currentCell?.toLabel.text
            DetailTripVC.departureValue = currentCell?.departureLabel.text
            DetailTripVC.returnValue = currentCell?.returnLabel.text
            DetailTripVC.priceValue = "$"+String(describing: currentCell?.priceLabel)
            DetailTripVC.userValue = currentCell?.userLabel
        
        if daysLeft((currentCell?.departureLabel.text!)!) != 0{
            DetailTripVC.daysLeftValue = String(daysLeft((currentCell?.departureLabel.text!)!)) + " " + "Days Left"}
        else{
            DetailTripVC.daysLeftValue = "Trip expired"
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
