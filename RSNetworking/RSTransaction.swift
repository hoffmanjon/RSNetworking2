//
//  RSTransaction.swift
//  RSNetworkSample
//
//  Created by Jon Hoffman on 7/25/14.
//  Copyright (c) 2014 Jon Hoffman. All rights reserved.
//

import Foundation

enum RSTransactionType {
    case GET
    case POST
    case UNKNOWN
}

class RSTransaction: NSObject {
    var transactionType = RSTransactionType.UNKNOWN
    var baseURL: String
    var path: String
    var parameters : [String:String]
    
    init(transactionType: RSTransactionType, baseURL: String,  path: String, parameters: [String: String]) {
        self.transactionType = transactionType
        self.baseURL = baseURL
        self.path = path
        self.parameters = parameters
    }
    
    func getFullURLString() -> String {
        return removeSlashFromEndOfString(self.baseURL) + "/" + removeSlashFromStartOfString(self.path)
    }
    
    
    private func removeSlashFromEndOfString(string: String) -> String
    {
        if string.hasSuffix("/") {
            return string.substringToIndex(string.endIndex.predecessor())
        } else {
            return string
        }
        
    }
    
    private func removeSlashFromStartOfString(string : String) -> String {
        if string.hasPrefix("/") {
            return string.substringFromIndex(string.startIndex.successor())
        } else {
            return string
        }
    }
}
