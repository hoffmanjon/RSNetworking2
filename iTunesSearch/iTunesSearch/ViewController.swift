//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Jon Hoffman on 7/29/14.
//  Copyright (c) 2014 Jon Hoffman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var searchButton : UIButton!
    @IBOutlet var searchTextField : UITextField!
    @IBOutlet var resultsTableView : UITableView!
    @IBOutlet var testButton : UIButton!
    
    var tableData: NSArray = NSArray()
    var rsRequest: RSTransactionRequest = RSTransactionRequest()
    var rsTransGet: RSTransaction = RSTransaction(transactionType: RSTransactionType.GET, baseURL: "https://itunes.apple.com", path: "search", parameters: ["term":"Jimmy+Buffett","media":"music"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any  setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //check to see if host is reachable
        if (!RSUtilities.isNetworkAvailable("www.apple.com")) {
            _ = RSUtilities.networkConnectionType("www.apple.com")
            
            //If host is not reachable, display a UIAlertController informing the user
            let alert = UIAlertController(title: "Alert", message: "You are not conected to the Internet", preferredStyle: UIAlertControllerStyle.Alert)
            
            //Add alert action
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            //Present alert
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func search(_: AnyObject) {
        
        //Get text for search
        let text: String = searchTextField.text!;
        
        //Convert spaces to "+"
        let searchText = text.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        //Set the parameters for the RSTransaction object
        rsTransGet.parameters = ["term":searchText,"media":"music"]
        
        //Send request
        rsRequest.dictionaryFromRSTransaction(rsTransGet, completionHandler: {(response : NSURLResponse!, responseDictionary: NSDictionary!, error: NSError!) -> Void in
            if error == nil {
                //Set the tableData NSArray to the results that were returned from the iTunes search and reload the table
                self.tableData = responseDictionary["results"] as! NSArray
                if self.tableData.count > 0 {
                    let rowData: NSDictionary = self.tableData[0] as! NSDictionary
                    let url = rowData["artworkUrl60"] as! String
                    self.testButton.setButtonImageForURL(url, placeHolder: UIImage(named: "loading")!, state:.Normal)
                }
                self.resultsTableView.reloadData()
            } else {
                //If there was an error, log it
                print("Error : \(error)")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableView delegate methods are below:
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let kCellIdentifier: String = "MyCell"
        
        //tablecell optional to see if we can reuse cell
        var cell : UITableViewCell?
        cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) 
        
        //If we did not get a reuseable cell, then create a new one
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
        
        //Get the data from the NSArray
        let rowData: NSDictionary = self.tableData[indexPath.row] as! NSDictionary
        
        //Set the text of the cell
        cell!.textLabel!.text =  rowData["trackName"] as? String
        
        //Set the detailText of the cell
        cell!.detailTextLabel!.text = rowData["trackCensoredName"] as? String
        
        //Use the setImageForURL method added to the UIImageView by the
        //RSNetworking catagory to load an image from a URL.
        //While the image loads we use a placeholder image
        let imageURL = rowData["artworkUrl60"] as! String
        let mCell = cell
        mCell!.imageView!.setImageForURL(imageURL, placeHolder: UIImage(named: "loading")!)
        
        return cell
        
    }
    
}

