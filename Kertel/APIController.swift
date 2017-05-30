//
//  APIController.swift
//  Kertel
//
//  Created by Kertel on 09/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation


class APIController {
    
    
    var delegateHistoryCall: APIDelegate?
    var delegateMevo: APIDelegate?
    var delegateConnect: APIDelegate?
    var token : String!
    let baseUrl = "https://at.mosaica.kertel.com/appli/api/"
    let authUrl = "auth"
    
    
    func getToken(delegate : APIDelegate, username : String?, company : String?, password : String?)
    {
        self.delegateConnect = delegate
        print("APIController -> getToken()")
        /*print("username: \(String(describing: username))")
        print("company: \(String(describing: company))")
        print("password: \(String(describing: password))")*/
        
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache",
            "postman-token": "5031c394-9149-8934-d860-1b3ec97b629c"
        ]
        
        let postData : NSData = NSData(data: "\\{\"username\":\"nsemhoun\",\"password\":\"nsemhoun\",\"company\":\"Active\"\\}".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl + authUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("auth fail")
                print(error ?? "empty error")
                self.delegateConnect?.fail(msgError: error.debugDescription)
            } else {
                print("auth success")
                
                let httpResponse = response as? HTTPURLResponse
                if (httpResponse?.statusCode == 400)
                {
                    if let d = data {
                        do {
                            if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                self.token = dic["token_auth"] as? String
                                print(self.token)
                                self.delegateConnect?.success(data: [AnyObject]())
                                return
                            }
                        }
                        catch (let err) {
                            print(err)
                        }
                    }
                }
                self.delegateConnect?.fail(msgError: "error HTTP : " + String(describing: httpResponse?.statusCode))
            }
        })
        
        dataTask.resume()
    }
    
    /*func gettToken(_ code: String) {
        let request = NSMutableURLRequest(url: "url" as URL)
        let query = "grant_type=" + Config().grantType + "&client_id=" + Config().UID + "&client_secret=" + Config().SECRET + "&code=" + code + "&redirect_uri=" + "https://www.42.fr"
        request.httpMethod = "POST"
        request.httpBody = query.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            // print(response)
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        self.token = dic["access_token"] as? String
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }*/
    
    
}



