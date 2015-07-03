//
//  UIButton+RSNetworking.swift
//  iTunesSearch
//
//  Created by Jon Hoffman on 8/25/14.
//  Copyright (c) 2014 Jon Hoffman. All rights reserved.
//

import UIKit

extension UIButton {
    func setButtonImageForURL(urlStr: String, placeHolder: UIImage, state: UIControlState) -> Void{
        self.setBackgroundImage(placeHolder, forState:state)
        setButtonImageForURL(urlStr,state: state)
    }
    
    func setButtonImageForURL(urlStr: String, state: UIControlState) -> Void {
        let url = NSURL(string: urlStr)
        let client = RSURLRequest()
        client.imageFromURL(url!, completionHandler: {(response : NSURLResponse!, image: UIImage!, error: NSError!) -> Void in
            self.setBackgroundImage(image, forState:state)

        })
    }
 
    func setButtonImageForRSTransaction(transaction:RSTransaction, placeHolder: UIImage, state: UIControlState) -> Void {
        self.setBackgroundImage(placeHolder, forState:state)
        setButtonImageForRSTransaction(transaction, state: state)
    }
    
    func setButtonImageForRSTransaction(transaction:RSTransaction, state: UIControlState) -> Void {
        let RSRequest = RSTransactionRequest();
        
        RSRequest.imageFromRSTransaction(transaction, completionHandler: {(response: NSURLResponse!, image: UIImage!, error: NSError!) -> Void in
            self.setBackgroundImage(image, forState:state)
        })
        
    }

}
