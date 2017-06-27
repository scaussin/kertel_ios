//
//  APIController.swift
//  Kertel
//
//  Created by Kertel on 09/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation


class APIController {
    
    
    var delegateGetIncomingCall: APIDelegate?
    var delegateGetOutgoingCall: APIDelegate?
    var delegateMevo: APIDelegate?
    var delegateConnect: APIDelegate?
    var token : String?
    let baseUrl = "https://at.mosaica.kertel.com/appli/api/"
    let authUrl = "auth"
    let incomingCallUrl = "calls/incoming"
    let outgoingCallUrl = "calls/outgoing"
    
    
    func getToken(delegate : APIDelegate, username : String!, company : String!, password : String!)
    {
        self.delegateConnect = delegate
        
        /*print("username: \(String(describing: username))")
        print("company: \(String(describing: company))")
        print("password: \(String(describing: password))")*/
        
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        //print("{\"username\":\"\(username!)\",\"password\":\"\(password!)\",\"company\":\"\(company!)\"}")
        let postData : NSData = NSData(data: "{\"username\":\"\(username!)\",\"password\":\"\(password!)\",\"company\":\"\(company!)\"}".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl + authUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
     
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                print("request getToken fail")
                print(error?.localizedDescription ?? "empty error")
                self.delegateConnect?.fail(msgError: error?.localizedDescription ?? "erreur")
            } else {
                //print("request getToken success")
                
                let httpResponse = response as? HTTPURLResponse
                if (httpResponse?.statusCode == 200)
                {
                    if let d = data {
                        do {
                            if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                self.token = dic["token_auth"] as? String
                                
                                self.delegateConnect?.success(data: [AnyObject]())
                                return
                            }
                        }
                        catch (let err) {
                            print("data auth fail")
                            print(err)
                        }
                    }
                }
                self.delegateConnect?.fail(msgError: error?.localizedDescription ?? "erreur")
            }
        })
        
        dataTask.resume()
    }
    

    func checkToken(delegate : APIDelegate) -> Bool
    {
        if token != nil {
            return true
        }
        else
        {
            delegate.fail(msgError: "APIController.token empty")
            return (false)
        }
    }
    
    func getIncomingCall(delegate : APIDelegate)
    {
        self.delegateGetIncomingCall = delegate
        if (checkToken(delegate: delegate) == false)
        {
            return
        }
        
        let headers = [
            "content-type": "application/json",
            "auth-token": token!,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl + incomingCallUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("request getIncomingCall fail")
                print(error?.localizedDescription ?? "empty error")
                self.delegateGetIncomingCall?.fail(msgError: error?.localizedDescription ?? "erreur")
            } else {
                //print("request getIncomingCall success")
                
                let httpResponse = response as? HTTPURLResponse
                if (httpResponse?.statusCode == 200)
                {
                    if let d = data {
                        do {
                            if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                var incomingCalls : [CallHistory] = []
                                if let datas = dic["datas"] as? [[String: Any]] {
                                    
                                    for data in datas
                                    {
                                        incomingCalls.append(CallHistory(callId: data["id"] as! String,
                                                                         name: data["src_name"] as? String,
                                                                         number: data["src_number"] as? String,
                                                                         state: data["state"] as! String,
                                                                         duration: data["duration"] as! Double,
                                                                         date: Date(timeIntervalSince1970 : data["date"] as! Double),
                                                                         isIncoming: true,
                                                                         isSeen: data["seen"] as! Bool))
                                        
                                    }
                                }
                                //print("data GetIncomingCall success")
                                
                                self.delegateGetIncomingCall?.success(data: incomingCalls as [AnyObject] )
                                return
                            }
                        }
                        catch (let err) {
                            print("data GetIncomingCall fail")
                            print(err)
                        }
                    }
                }
                self.delegateGetIncomingCall?.fail(msgError: error?.localizedDescription ?? "erreur")
            }
        })
        dataTask.resume()
    }
    
    func getOutgoingCall(delegate : APIDelegate)
    {
        self.delegateGetOutgoingCall = delegate
        if (checkToken(delegate: delegate) == false)
        {
            return
        }
        
        let headers = [
            "content-type": "application/json",
            "auth-token": token!,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl + outgoingCallUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("request getOutgoingCall fail")
                print(error?.localizedDescription ?? "empty error")
                self.delegateGetOutgoingCall?.fail(msgError: error?.localizedDescription ?? "erreur")
            } else {
                //print("request getIncomingCall success")
                
                let httpResponse = response as? HTTPURLResponse
                if (httpResponse?.statusCode == 200)
                {
                    if let d = data {
                        do {
                            if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                var outgoingCalls : [CallHistory] = []
                                if let datas = dic["datas"] as? [[String: Any]] {
                                    
                                    for data in datas
                                    {
                                        outgoingCalls.append(CallHistory(callId: data["id"] as! String,
                                                                         name: data["src_name"] as? String,
                                                                         number: data["dst_number"] as? String,
                                                                         state: data["state"] as! String,
                                                                         duration: data["duration"] as! Double,
                                                                         date: Date(timeIntervalSince1970 : data["date"] as! Double),
                                                                         isIncoming: false,
                                                                         isSeen: true))
                                        
                                    }
                                }
                                self.delegateGetOutgoingCall?.success(data: outgoingCalls as [AnyObject] )
                                return
                            }
                        }
                        catch (let err) {
                            print("data GetOutgoingCall fail")
                            print(err)
                        }
                    }
                }
                self.delegateGetOutgoingCall?.fail(msgError: error?.localizedDescription ?? "erreur")
            }
        })
        dataTask.resume()
    }

    
    func disconnect()
    {
        delegateGetIncomingCall =  nil
        delegateMevo = nil
        delegateConnect = nil
        token = nil
    }

}



