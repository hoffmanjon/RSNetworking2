RSNetworking 2
=====================

RSNetworking 2 is a version of RSNetworking that is written to work with Swift 2

RSNetworking is the start of a networking library written entirly for the Swift programming language.  If you would like to assist in the development of RSNetworking 2, or have features that you would like to see, please let me know.

You can read my blog post for additional information about this update:  

If you receive an error like this: 
``` 
  NSURLSession/NSURLConnection HTTP load failed (kCFStreamErrorDomainSSL, -9824)
  Error : Error Domain=NSURLErrorDomain Code=-1200 "An SSL error has occurred and 
  a secure connection to the server cannot be made."
```
You are running into App Transport Security which enforces best practices for secure connections.  This is the default for iOS9 and OX X 10.11.  ATS requires communication over HTTPS and the use of TLS 1.2.  One thing to note, Apple's own iTunes API (as shown in the example code) does not support TLS 1.2 so you will get this error connecting to the iTunes API.  To correct this issue, you need to add the following lines to your apps infor.plist file:
```
   <key>NSAppTransportSecurity</key>
   <dict>
       <key>NSAllowsArbitraryLoads</key>
       <true/>
   </dict>
```

------------

## Classes

###RSTransaction  

RSTransaction is the class that defines the transaction we wish to make.  It exposes four properties, one initiator and one method.

#####Properties  

* TransactionType - This defines the HTTP request method.  Currently there are three types, GET, POST, UNKNOWN.  Only the GET and POST actually sends a request.  

* baseURL - This is the base URL to use for the request.  This will normally look something like this:  "https://itunes.apple.com".  If you are going to a non-standard port you would put that here as well.  It will look something like this:  "http://mytestserver:8080"  

* path - The path that will be added to the base url.  This will normally be something like this: "search".  It can also include a longer path string like: "path/to/my/service"  

* parameters - Any parameters to send to the service.

#####initiators

* init(transactionType: RSTransactionType, baseURL: String,  path: String, parameters: [String: String]) - This will initialize the RSTransaction with all properties needed.

#####Functions  

* getFullURLString() -> String - Builds and returns the full URL needed to connect to the service.


###RSTransactionRequest  

RSTransactionRequest is the class that builds and send out the request to the service defined by the RSTransaction.  It exposes four functions.  

#####Functions  

* dataFromRSTransaction(transaction: RSTransaction, completionHandler handler: RSNetworking.dataFromRSTransactionCompletionCompletionClosure):  Retrieves an NSData object from the service defined by the RSTransaction.  This is the main function and is used by the other three functions to retrieve an NSData object prior to converting it to the required format.

* stringFromRSTransaction(transaction: RSTransaction, completionHandler handler:  RSNetworking.stringFromRSTransactionCompletionCompletionClosure):  Retrieves an NSString object from the service defined by the RSTransaction.  This function uses the dataFromRSTransaction function to retrieve an NSData object and then converts it to an NSString object.

* dictionaryFromRSTransaction(transaction: RSTransaction, completionHandler handler:  RSNetworking.dictionaryFromRSTransactionCompletionCompletionClosure):  Retrieves an NSDictionary object from the service defined by the RSTransaction.  This function uses the dataFromRSTransaction function to retrieve an NSData object and then converts it to an NSDictionary object.  The data returned from the URL should be in JSON format for this function to work properly.

* imageFromRSTransaction(transaction: RSTransaction, completionHandler handler:  RSNetworking.imageFromRSTransactionCompletionCompletionClosure):  Retrieves an UIImage object from the service defined by the RSTransaction.  This function uses the dataFromRSTransaction function to retrieve an NSData object and then converts it to an UIImage object.

###RSURLRequest  

RSURLRequest will send a GET request to a service with just a URL.  There is no need to defince a RSTransaction to use this class.  RSURLRequest exposes four functions.  

#####Functions  

* dataFromURL(url: NSURL, completionHandler handler: RSNetworking.dataFromURLCompletionClosure):  Retrieves an NSData object from the URL passed in.  This is the main function and is used by the other three functions to retrieve an NSData object prior to converting it to the required format

* stringFromURL(url: NSURL, completionHandler handler:  RSNetworking.stringFromURLCompletionClosure):  Retrieves an NSString object from the URL passed in.  This function uses the dataFromURL function to retrieve an NSData object and then converts it to an NSString object.

* dictionaryFromJsonURL(url: NSURL, completionHandler handler:  RSNetworking.dictionaryFromURLCompletionClosure):  Retrieves an NSDictionary object from the URL passed in.  This function uses the dataFromURL function to retrieve an NSData object and then converts it to an NSDictionary object.  The data returned from the URL should be in JSON format for this function to work properly.

* imageFromURL(url: NSURL, completionHandler handler:  RSNetworking.imageFromURLCompletionClosure):  Retrieves an UIImage object from the URL.  This function uses the dataFromURL function to retrieve an NSData object and then converts it to an UIImage object.

###RSUtilities  

RSUtilities will contain various utilities that do not have their own class.  Currently there is only one function exposed by this class

#####Functions  

* isHostnameReachable(hostname: NSString) -> Bool - WILL BE DEPRECIATED SOON.  This function will check to see if a host is available or not.  This is a class function.
* isNetworkAvailable(hostname: NSString) -> Bool  -  This function will check to see if the network is available.  This is a class function.
* networkConnectionType(hostname: NSString) -> ConnectionType  -  This function will return the type of network connection that is available.  The ConnectionType is an enum which can equal one of the following three types:  NONETWORK, MOBILE3GNETWORK or WIFINETWORK.

## Extensions

Here is a list of extensions provided

* UIImageView
     - setImageForURL(url: NSString, placeHolder: UIImage):  Sets the image in the UIImageView to the placeHolder image and then asynchronously downloads the image from the URL.  Once the image downloads it will replace the placeholder image with the downloaded image.
     - setImageForURL(url: NSString):  Asynchronously downloads the image from the URL.  Once the image is downloaded, it sets the image of the UIImageView to the downloaded image.
     - setImageForRSTransaction(transaction:RSTransaction, placeHolder: UIImage):  Sets the image in the UIImageView to the placeHolder image and then asynchronously downloads the image from the RSTransaction.  Once the image downloads it will replace the placeholder image with the downloaded image.
     - setImageForRSTransaction(transaction:RSTransaction):  Asynchronously downloads the image from the RSTransaction.  Once the image downloads it sets the image of the UIImageView to the downloaded image.


*  UIButton
     -  setButtonImageForURL(url: NSString, placeHolder: UIImage, state: UIControlState):  Sets the background image of the UIButton to the placeholder image and then asynchronously downloads the image from the URL.  Once the image downloads it will replace the placeHolder image with the downloaded image.
     -  setButtonImageForURL(url: NSString, state: UIControlState):  Asynchronously downloads the image from the URL.  Once the download is complete, it will set the background image of the UIButton to the downloaded image.
     -  setButtonImageForRSTransaction(transaction:RSTransaction, placeHolder: UIImage, state: UIControlState):  Sets the background image of the UIButton to the placeHolder image and then asynchronously downloads the image from the URL.  Once the image downloads it will replace the placeHolder image with the downloaded image.
     -  setButtonImageForRSTransaction(transaction:RSTransaction, state: UIControlState):  Asynchronously downloads the image from the URL.  Once the download is complete, it will set the background image of the UIButton to the downloaded image.
		
-------------


Sample code for Networking Library

##RSURLRequest

#### dataFromURL
```

  let client = RSURLRequest()
  
  if let testURL = NSURL(string:"https://itunes.apple.com/search?term=jimmy+buffett&media=music") {
      
      client.dataFromURL(testURL, completionHandler: {(response : NSURLResponse!, responseData: NSData!, error: NSError!) -> Void in
          if let error = error {
              print("Error : \(error)")
          } else {
              let string = NSString(data: responseData, encoding: NSUTF8StringEncoding)
              print("Response Data: \(string)")
          }
      }) 
  }
```
        
#### dictionaryFromJsonURL
```

  let client = RSURLRequest()
  
  if let testURL = NSURL(string:"https://itunes.apple.com/search?term=jimmy+buffett&media=music") {
      
      client.dictionaryFromJsonURL(testURL, completionHandler: {(response : NSURLResponse!, responseDictionary: NSDictionary!, error: NSError!) -> Void in
          if let error = error {
              print("Error : \(error)")
          } else {
              print("Response Dictionary: \(responseDictionary)")
          }
      })
  }
```

#### stringFromURL  
```     

  let client = RSURLRequest()
  
  if let testURL = NSURL(string:"https://itunes.apple.com/search?term=jimmy+buffett&media=music") {
      
      client.stringFromURL(testURL, completionHandler: {(response : NSURLResponse!, responseString: NSString!, error: NSError!) -> Void in
          if let error = error {
              print("Error : \(error)")
          } else {
              print("Response Data: \(responseString)")
          }
      })
  }
```
 
#### imageFromURL  
```         

  let client = RSURLRequest()
  
  if let imageURL = NSURL(string:"http://a1.mzstatic.com/us/r30/Music/y2003/m12/d17/h16/s05.whogqrwc.100x100-75.jpg") {
      
      client.imageFromURL(imageURL, completionHandler: {(response : NSURLResponse!, image: UIImage!, error: NSError!) -> Void in
          if let error = error {
              print("Error : \(error)")
          } else {
              self.imageView?.image = image;
          }
      })
  }
```

#### RSUtilities.isHostnameReachable
```

  if (RSUtilities.isNetworkAvailable("www.apple.com")) {
      print("reachable")
  } else {
      print("Not Reachable")
  }
```
        
#### UIImageView:  setImageForURL
```

  let imageURL = "http://a1.mzstatic.com/us/r30/Music/y2003/m12/d17/h16/s05.whogqrwc.100x100-75.jpg"
  imageView.setImageForURL(imageURL, placeHolder: UIImage(named: "loading"))	
  
  or
  
  let imageURL = "http://a1.mzstatic.com/us/r30/Music/y2003/m12/d17/h16/s05.whogqrwc.100x100-75.jpg"
  self.imageView?.setImageForURL(imageURL)
```

#### UIButton:  setImageForURL
```

  let imageURL = "http://a1.mzstatic.com/us/r30/Music/y2003/m12/d17/h16/s05.whogqrwc.100x100-75.jpg"
  button.setButtonImageForURL(url, placeHolder: UIImage(named: "loading"), state:.Normal)
  
  or
  
  let imageURL = "http://a1.mzstatic.com/us/r30/Music/y2003/m12/d17/h16/s05.whogqrwc.100x100-75.jpg"
  button.setButtonImageForURL(url, state:.Normal)
```



###RSTransactionRequest  
RSTransactionRequest is designed to be used when you need to create mulitple requests to the same service.  It allows you to set up the request once and then just change the parameters for each request

####dictionaryFromRSTransaction
```

  let rsRequest = RSTransactionRequest()
      
  //Create the initial request
  let rsTransGet = RSTransaction(transactionType: RSTransactionType.GET, baseURL: "https://itunes.apple.com", path: "search", parameters: ["term":"jimmy+buffett","media":"music"])
  
  rsRequest.dictionaryFromRSTransaction(rsTransGet, completionHandler: {(response : NSURLResponse!, responseDictionary: NSDictionary!, error: NSError!) -> Void in
      if let error = error {
          print("Error : \(error)")
      } else {
          print(responseDictionary)
      }
  })
  
    
```            

Now that you have the RSTransaction, you can simply change the parameters and make another request, if needed, like this:
```

  let rsRequest = RSTransactionRequest()
  
  //Create the initial request
  rsTransGet.parameters = ["term":"Jimmy", "media":"music"]
  rsRequest.dictionaryFromRSTransaction(rsTransGet, completionHandler: {(response : NSURLResponse!, responseDictionary: NSDictionary!, error: NSError!) -> Void in
      if let error = error {
          print("Error : \(error)")
      } else {
          print(responseDictionary)
      }
  })
```

####stringFromRSTransaction
```

  //Change parameters from the previously example so we can make a second request
  rsTransGet.parameters = ["term":"Jimmy", "media":"music"]
  rsRequest.stringFromRSTransaction(rsTransGet, completionHandler: {(response : NSURLResponse!, responseString: NSString!, error: NSError!) -> Void in
      if let error = error {
          print("Error : \(error)")
      } else {
          print(responseString)
      }
  })
``` 

