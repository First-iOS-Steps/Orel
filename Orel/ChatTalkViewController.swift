//
//  ChatTalkViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 4/10/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse

var otherProfileName = ""

class ChatTalkViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {

    @IBOutlet weak var resultScrollView: UIScrollView!
    
    @IBOutlet weak var frameMsgView: UIView!
    
    
    @IBOutlet weak var lineLabel: UILabel!
    
    
    @IBOutlet weak var msgTextView: UITextView!
    
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    var scrollViewOriginalY:CGFloat = 0
    var frameMessageOriginalY:CGFloat = 0
    
    let placeholderLabel = UILabel(frame: CGRect(x: 5, y: 10, width: 200, height: 20))
    
    var messageX:CGFloat = 37.0 // message coordinates
    var messageY:CGFloat = 26.0
    
    var frameX:CGFloat = 32.0 // bubble coordinate that hold message
    var frameY:CGFloat = 21.0
    
    var imgX:CGFloat = 3 //small image circle coordinates
    var imgY:CGFloat = 3
    
    var myImg:UIImage? = UIImage()//current user image
    var otherImg:UIImage? = UIImage()//other user image
    
    var resultsImageFiles = [PFFile]()
    var resultsImageFiles2 = [PFFile]()
    
    var messageArray = [String]() //store messages
    var senderArray = [String]() //store sender

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultScrollView.frame = CGRect(x: 0, y: 64, width: theWidth, height: theHeight-114) //50 the height of the view + 64 the bar
        resultScrollView.layer.zPosition = 20
        
        frameMsgView.frame = CGRect(x: 0, y: resultScrollView.frame.maxY, width: theWidth, height: 50) //starts where scroll view ends
        lineLabel.frame = CGRect(x: 0, y: 0, width: theWidth, height: 1)
        msgTextView.frame = CGRect(x: 2, y: 1, width: self.frameMsgView.frame.size.width-52, height: 48)
        sendButton.center = CGPoint(x: frameMsgView.frame.size.width-30, y: 24)
        
        scrollViewOriginalY = self.resultScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMsgView.frame.origin.y
        
        self.view.backgroundColor = UIColor(patternImage: (UIImage(named: "blurback.jpg"))!)

        print(otherProfileName)


        self.title = otherProfileName

        placeholderLabel.text = "Type a message..."
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.textColor = UIColor.lightGray
        msgTextView.addSubview(placeholderLabel)

        NotificationCenter.default.addObserver(self, selector: #selector(ChatTalkViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatTalkViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: #selector(ChatTalkViewController.didTapScrollView))
        tapScrollViewGesture.numberOfTapsRequired = 1
        resultScrollView.addGestureRecognizer(tapScrollViewGesture)
        
       // var chatTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("refreshResults"), userInfo: nil, repeats: true)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        
        if msgTextView.text == "" {
            print("no text")
        } else {
            
            let messageDBTable = PFObject(className: "Messages")
            messageDBTable["sender"] = userName
            messageDBTable["other"] = otherProfileName
            messageDBTable["message"] = self.msgTextView.text
            messageDBTable.saveInBackground {
                (success:Bool, error:NSError?) -> Void in
                
                if success == true {
        
                    self.msgTextView.text = ""
                    self.placeholderLabel.isHidden = false
                    self.refreshResults()
                    self.view.endEditing(true)
                    
                    
                }
                
                
            }
            
        }
    }
    func didTapScrollView(){
        
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !msgTextView.hasText{
        
        self.placeholderLabel.isHidden = false
        }else {
            self.placeholderLabel.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !msgTextView.hasText{
            self.placeholderLabel.isHidden = false
        }
    }
    
    func keyboardWasShown(_ notification: Notification) {
        let dict : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let s: NSValue = dict.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect: CGRect = s.cgRectValue
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            
            self.resultScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
            self.frameMsgView.frame.origin.y = self.frameMessageOriginalY - rect.height
            
            let bottomOffset:CGPoint = CGPoint(x: 0, y: self.resultScrollView.contentSize.height - self.resultScrollView.bounds.size.height)
            self.resultScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })
        
    }
    
    
    func keyboardWillHide(_ notification: Notification){
        
        let dict : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let s: NSValue = dict.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect: CGRect = s.cgRectValue
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            
            self.resultScrollView.frame.origin.y = self.scrollViewOriginalY
            self.frameMsgView.frame.origin.y = self.frameMessageOriginalY
            
            let bottomOffset:CGPoint = CGPoint(x: 0, y: self.resultScrollView.contentSize.height - self.resultScrollView.bounds.size.height)
            self.resultScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: userName) //get row where current user is
        let objects = try! query.findObjects()  //UPDATE THIS
        
        self.resultsImageFiles.removeAll(keepingCapacity: false) // empty array
        
        for object in objects {  //UPDATE THIS
            
            self.resultsImageFiles.append(object["imageFile"] as! PFFile) //get the image from the user and store it
            
            self.resultsImageFiles[0].getDataInBackground {
                (imageData:Data?, error:NSError?) -> Void in
                
                if error == nil {
                    
                    self.myImg = UIImage(data: imageData!) //assign this image to our variable
                    
                    let query2 = PFQuery(className: "_User")
                    query2.whereKey("username", equalTo: otherProfileName) //get the row where the other user is
                    let objects2 = try! query2.findObjects()  //UPDATE THIS
                    
                    self.resultsImageFiles2.removeAll(keepingCapacity: false) // empty his array
                    
                    for object in objects2 {   //UPDATE THIS
                        
                        self.resultsImageFiles2.append(object["imageFile"] as! PFFile) //store the other use image
                        
                        self.resultsImageFiles2[0].getDataInBackground {
                            (imageData:Data?, error:NSError?) -> Void in
                            
                            
                            if error == nil {
                                
                                self.otherImg = UIImage(data: imageData!) //assing the other image to the variable
                                
                                self.refreshResults() //call refresh results
                                
                            }}}}}}
        
    }
    
    
    func refreshResults() {
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        messageX = 37.0
        messageY = 26.0
        
        frameX = 32.0
        frameY = 21.0
        
        imgX = 3
        imgY = 3
        
        messageArray.removeAll(keepingCapacity: false)
        senderArray.removeAll(keepingCapacity:  false)
        
        //sender will be equal to userName which is the current user
        //other will be the receiver which is the user you are chatting with
        let innerP1 = NSPredicate(format: "sender = %@ AND other = %@", userName, otherProfileName)
        let innerQ1:PFQuery = PFQuery(className: "Messages", predicate: innerP1)
        
        //the oposite here
        let innerP2 = NSPredicate(format: "sender = %@ AND other = %@", otherProfileName, userName)
        let innerQ2:PFQuery = PFQuery(className: "Messages", predicate: innerP2)
        
        //compare where the sender and the receiver are the same to retreive conversation and not mess up with others
        let query = PFQuery.orQuery(withSubqueries: [innerQ1,innerQ2])
        query.addAscendingOrder("createdAt") // retreve the messages in the right order so it makes sense
        
        
        query.findObjectsInBackground {
            (objects:[PFObject]?, error:NSError?) -> Void in  //UPDATE THIS
            
            if error == nil {
                
                for object in objects! {
                    
                    self.senderArray.append(object.object(forKey: "sender") as! String) //store sender
                    self.messageArray.append(object.object(forKey: "message") as! String) //store message
                    
                }
                
                for subView in self.resultScrollView.subviews {
                    subView.removeFromSuperview() //empty anything before retreiving messages
                    
                }
                

                for var i = 0; i <= self.messageArray.count-1; i++ { //loop through messages

                    if self.senderArray[i] == userName {//check if the sender is the logged user
                        
                        var messageLabel : UILabel = UILabel() //create label to hold message
                        messageLabel.frame = CGRect(x: 0, y: 0, width: self.resultScrollView.frame.size.width-94, height: CGFloat.max)//determines max width so it knows when it create new lines
                        messageLabel.backgroundColor = UIColor.clear
                        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping //wrap label
                        messageLabel.textAlignment = NSTextAlignment.left //float label to left
                        messageLabel.numberOfLines = 0
                        messageLabel.font = UIFont(name: "Arial", size: 20) //decide label font
                        messageLabel.textColor = UIColor.white //decide label color
                        messageLabel.text = self.messageArray[i] //get actual message from array
                        messageLabel.sizeToFit() //make background fit to label
                        messageLabel.layer.zPosition = 20
                        messageLabel.frame.origin.x = (self.resultScrollView.frame.size.width - self.messageX) - messageLabel.frame.size.width //x coordinates for message to be displayed on left side of the screen
                        messageLabel.frame.origin.y = self.messageY //give label the minimal height
                        self.resultScrollView.addSubview(messageLabel) //add label to the scroll view to display
                        self.messageY += messageLabel.frame.size.height + 30 //stack labels since there will be many
                        
                        var frameLabel: UILabel = UILabel()
                        frameLabel.frame.size = CGSize(width: messageLabel.frame.size.width + 10, height: messageLabel.frame.size.height + 10)
                        frameLabel.frame.origin.x = self.resultScrollView.frame.size.width - self.frameX - frameLabel.frame.size.width
                        frameLabel.frame.origin.y = self.frameY
                        frameLabel.backgroundColor = UIColor.orange
                        frameLabel.layer.masksToBounds = true
                        frameLabel.layer.cornerRadius = 10
                        
                        self.resultScrollView.addSubview(frameLabel)
                        
                        self.frameY += frameLabel.frame.size.height + 20
                        
                        var img: UIImageView = UIImageView()
                        img.image = self.myImg
                        img.frame.size = CGSize(width: 34, height: 34)
                        img.frame.origin.x = self.resultScrollView.frame.size.width - self.imgX - img.frame.size.width
                        img.frame.origin.y = self.imgY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width / 2
                        img.clipsToBounds = true
                        self.resultScrollView.addSubview(img)
                        
                        self.imgY += frameLabel.frame.size.height + 20
                        
                        
                        
                        self.resultScrollView.contentSize = CGSize(width: theWidth, height: self.messageY) //make all of them fit in scroll view
                        
                        
                        
                    }else {
                        
                        
                        
                        var messageLabel : UILabel = UILabel() //create label to hold message
                        messageLabel.frame = CGRect(x: 0, y: 0, width: self.resultScrollView.frame.size.width-94, height: CGFloat.max) //determines max width so it knows when it create new lines
                        messageLabel.backgroundColor = UIColor.clear
                        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping //wrap label
                        messageLabel.textAlignment = NSTextAlignment.left //float label to left
                        messageLabel.numberOfLines = 0
                        messageLabel.font = UIFont(name: "Arial", size: 20) //decide label font
                        messageLabel.textColor = UIColor.white //decide label color
                        messageLabel.text = self.messageArray[i] //get actual message from array
                        messageLabel.sizeToFit() //make background fit to label
                        messageLabel.layer.zPosition = 20
                        messageLabel.frame.origin.x = self.messageX // xcoordinates for right side
                        messageLabel.frame.origin.y = self.messageY //give label the minimal height
                        self.resultScrollView.addSubview(messageLabel) //add label to the scroll view to display
                        self.messageY += messageLabel.frame.size.height + 30 //stack labels since there will be many
                        
                        
                        
                        var frameLabel: UILabel = UILabel()
                        frameLabel.frame = CGRect(x: self.frameX, y: self.frameY, width: messageLabel.frame.size.width+10, height: messageLabel.frame.size.height+10)

                        frameLabel.backgroundColor = UIColor.lightGray
                        frameLabel.layer.masksToBounds = true
                        frameLabel.layer.cornerRadius = 10
                        
                        self.resultScrollView.addSubview(frameLabel)
                        
                        self.frameY += frameLabel.frame.size.height + 20
                        
                        
                        var img: UIImageView = UIImageView()
                        img.image = self.otherImg
                        
                        img.frame = CGRect(x: self.imgX, y: self.imgY, width: 34, height: 34)

                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width / 2
                        img.clipsToBounds = true
                        self.resultScrollView.addSubview(img)
                        
                        self.imgY += frameLabel.frame.size.height + 20

                        
                        
                        
                        self.resultScrollView.contentSize = CGSize(width: theWidth, height: self.messageY) //make all of them fit in scroll view
                        
                    }
                    let bottomOffset:CGPoint = CGPoint(x: 0, y: self.resultScrollView.contentSize.height - self.resultScrollView.bounds.size.height)
                    self.resultScrollView.setContentOffset(bottomOffset, animated: false)
                    
                
                
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
