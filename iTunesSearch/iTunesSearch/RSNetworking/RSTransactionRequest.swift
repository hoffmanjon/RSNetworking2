//
//  RSTransactionRequest.swift
//  RSNetworkSample
//
//  Created by Jon Hoffman on 7/25/14.
//  Copyright (c) 2014 Jon Hoffman. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

private func urlEncode(s: String) -> String {
    return CFURLCreateStringByAddingPercentEscapes(nil, s, nil, "!*'\"();:@&=+$,/?%#[]", CFStringBuiltInEncodings.UTF8.rawValue) as String
}

class RSTransactionRequest: NSObject {
    
    let dictKey = "results"
    
    typealias dataFromRSTransactionCompletionClosure = ((NSURLResponse!, NSData!, NSError!) -> Void)
    typealias stringFromRSTransactionCompletionClosure = ((NSURLResponse!, NSString!, NSError!) -> Void)
    typealias dictionaryFromRSTransactionCompletionClosure = ((NSURLResponse!, NSDictionary!, NSError!) -> Void)
    typealias imageFromRSTransactionCompletionClosure = ((NSURLResponse!, UIImage!, NSError!) -> Void)
    
    
    func dataFromRSTransaction(transaction: RSTransaction, completionHandler handler: dataFromRSTransactionCompletionClosure)
    {
        if (transaction.transactionType == RSTransactionType.GET) {
            dataFromRSTransactionGet(transaction, completionHandler: handler);
        } else if(transaction.transactionType == RSTransactionType.POST) {
            dataFromRSTransactionPost(transaction, completionHandler: handler);
        }
    }
    
    private func dataFromRSTransactionPost(transaction: RSTransaction, completionHandler handler: dataFromRSTransactionCompletionClosure)
    {
        
        let queue = NSOperationQueue()
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let urlString = transaction.getFullURLString()
        let url: NSURL = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL:url)
        request.HTTPMethod = "POST"
        let params = dictionaryToQueryString(transaction.parameters)
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        let urlSession = NSURLSession(configuration:sessionConfiguration, delegate: nil, delegateQueue: queue)
        
        urlSession.dataTaskWithRequest(request, completionHandler: {(responseData: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            handler(response,responseData,error)
        })!.resume()
    }
    
    private func dataFromRSTransactionGet(transaction: RSTransaction, completionHandler handler: dataFromRSTransactionCompletionClosure)
    {
        
        let queue = NSOperationQueue()
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let urlString = transaction.getFullURLString() + "?" + dictionaryToQueryString(transaction.parameters)
        let url: NSURL = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL:url)
        request.HTTPMethod = "GET"
        let urlSession = NSURLSession(configuration:sessionConfiguration, delegate: nil, delegateQueue: queue)
        
        urlSession.dataTaskWithRequest(request, completionHandler: {(responseData: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            handler(response,responseData,error)
        })!.resume()
    }
    
    func stringFromRSTransaction(transaction: RSTransaction, completionHandler handler: stringFromRSTransactionCompletionClosure) {
        dataFromRSTransaction(transaction, completionHandler: {(response: NSURLResponse!, responseData: NSData!, error: NSError!) -> Void in
            
            let responseString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
            handler(response,responseString,error)
        })
    }
    
    
    func dictionaryFromRSTransaction(transaction: RSTransaction, completionHandler handler: dictionaryFromRSTransactionCompletionClosure) {
        dataFromRSTransaction(transaction, completionHandler: {(response: NSURLResponse!, responseData: NSData!, error: NSError!) -> Void in
            
            if error != nil {
                handler(response,nil,error)
                return
            }
            
            var resultDictionary = NSMutableDictionary()
            var jsonResponse : AnyObject?
            do {
            jsonResponse  = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
            } catch {}
            
            if let jsonResponse = jsonResponse {
            switch jsonResponse {
            case is NSDictionary:
                resultDictionary = jsonResponse as! NSMutableDictionary
            case is NSArray:
                resultDictionary[self.dictKey] = jsonResponse
            default:
                resultDictionary[self.dictKey] = ""
            }
            } else {
                resultDictionary[self.dictKey] = ""
            }
            handler(response,resultDictionary.copy() as! NSDictionary,error)
        })
    }
    
    
    func imageFromRSTransaction(transaction: RSTransaction, completionHandler handler: imageFromRSTransactionCompletionClosure) {
        dataFromRSTransaction(transaction, completionHandler: {(response: NSURLResponse!, responseData: NSData!, error: NSError!) -> Void in
            
            if error != nil {
                handler(response,nil,error)
                return
            }
            
            let image = UIImage(data: responseData)
            handler(response,image?.copy() as! UIImage?,error)
        })
    }
    
    
    private func dictionaryToQueryString(dict: [String : String]) -> String {
        var parts = [String]()
        for (key, value) in dict {
            parts.append(urlEncode(key) + "=" + urlEncode(value));
        }
        return "&".join(parts)

    }
}
