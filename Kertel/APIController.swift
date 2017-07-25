//
//  APIController.swift
//  Kertel
//
//  Created by Kertel on 09/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation


class APIController {
    
    //to delete
    var delegateGetIncomingCall: APIDelegate?
    var delegateGetOutgoingCall: APIDelegate?
    var delegateDelIncomingCall: APIDelegate?
    var delegateMevo: APIDelegate?
    var delegateConnect: APIDelegate?
    
    
    var token : String?
    let baseUrl = "https://at.mosaica.kertel.com/appli/api/"
    let authUrl = "auth"
    let incomingCallUrl = "calls/incoming"
    let outgoingCallUrl = "calls/outgoing"
    let mevoUrl = "mevo/messages"
    let MevoDataUrl = "mevo/message"
    
    
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
                self.delegateConnect?.fail(msgError: error?.localizedDescription ?? "Veuillez vérifier vos informations de connexion")
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
    
    /*
     import Foundation
     
     let headers = [
     "content-type": "application/json",
     "auth-token": "a9472b72-513f-85ea-773f-44501ec631db",
     "cache-control": "no-cache",
     "postman-token": "7245f959-96a5-020e-c4fe-ad8e1996baa7"
     ]
     
     let postData = NSData(data: "{
     "call_ids": ["1594150",1594145]
     }".data(using: String.Encoding.utf8)!)
     
     let request = NSMutableURLRequest(url: NSURL(string: "http://at.mosaica.kertel.com/appli/api/calls/incoming")! as URL,
     cachePolicy: .useProtocolCachePolicy,
     timeoutInterval: 10.0)
     request.httpMethod = "DELETE"
     request.allHTTPHeaderFields = headers
     request.httpBody = postData as Data
     
     let session = URLSession.shared
     let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
     if (error != nil) {
     print(error)
     } else {
     let httpResponse = response as? HTTPURLResponse
     print(httpResponse)
     }
     })
     
     dataTask.resume()
     */
    
    func doRequest(httpMethod : String, sufixUrl : String, dataBody : NSData?, success : @escaping (NSDictionary) -> (), fail : @escaping (String) -> ())
    {
        if token == nil {
            fail("[FAIL] APIController.token is empty")
            return
        }
        let headers = [
            "content-type": "application/json",
            "auth-token": token!,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl + sufixUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = headers
        if let data = dataBody
        {
            request.httpBody = data as Data
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if (error != nil || httpResponse?.statusCode != 200) {
                fail("[FAIL] request " /*+ httpMethod + " " + self.baseUrl + self.incomingCallUrl + " detail: " + error?.localizedDescription*/)
                return
            }
            else
            {
                if let d = data
                {
                    do {
                        if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        {
                            success(dic)
                            return
                        }
                    }
                    catch (let err) {
                        print("data GetOutgoingCall fail")
                        print(err)
                    }
                }
                fail("[FAIL] extract data " /*+ httpMethod + " " + self.baseUrl + self.incomingCallUrl + " detail: " + error?.localizedDescription*/)
                return
            }
        })
        dataTask.resume()
        return
    }
    
    func doRequestGetRaw(httpMethod : String, sufixUrl : String, dataBody : NSData?, success : @escaping (Data?) -> (), fail : @escaping (String) -> ())
    {
        if token == nil {
            fail("[FAIL] APIController.token is empty")
            return
        }
        let headers = [
            "content-type": "application/json",
            "auth-token": token!,
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: baseUrl + sufixUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = headers
        if let data = dataBody
        {
            request.httpBody = data as Data
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            if (error != nil || httpResponse?.statusCode != 200) {
                fail("[FAIL] request " /*+ httpMethod + " " + self.baseUrl + self.incomingCallUrl + " detail: " + error?.localizedDescription*/)
                return
            }
            else
            {
                success(data)
                return
            }
        })
        dataTask.resume()
        return
    }
    
    func getIncomingCall(delegate : APIDelegate)
    {
        doRequest(httpMethod: "GET", sufixUrl : incomingCallUrl, dataBody: nil,
                  success : {(data) -> () in
                    
                    var incomingCalls : [CallHistory] = []
                    if let datas = data["datas"] as? [[String: Any]] {
                        
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
                    delegate.success(data: incomingCalls as [AnyObject] )
                    
        }, fail : {(err) -> () in
            delegate.fail(msgError: err)
        })
    }

    
    func getOutgoingCall(delegate : APIDelegate)
    {
        doRequest(httpMethod: "GET", sufixUrl : outgoingCallUrl, dataBody: nil,
                  success : {(data) -> () in
                    
                    var outgoingCalls : [CallHistory] = []
                    if let datas = data["datas"] as? [[String: Any]] {
                        
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
                   delegate.success(data: outgoingCalls as [AnyObject] )

        }, fail : {(err) -> () in
            delegate.fail(msgError: err)
        })
    }
    
    
    func delIncomingCall(delegate : APIDelegate, idCallsToDelete : [String])
    {
        var data = "{\"call_ids\": ["
        var i = 0
        while (i < idCallsToDelete.count)
        {
            data += "\"\(idCallsToDelete[i])\""
            if i != idCallsToDelete.count - 1 // not last
            {
                data += ","
            }
            i += 1
        }
        data += "]}"
        let postData = NSData(data: data.data(using: String.Encoding.utf8)!)

        doRequest(httpMethod: "DELETE", sufixUrl : incomingCallUrl, dataBody: postData,
                  success : {(data) -> () in
            delegate.success(data: nil)
        }, fail : {(err) -> () in
            delegate.fail(msgError: err)
        })
    }
    
    func delOutgoingCall(delegate : APIDelegate, idCallsToDelete : [String])
    {
        var data = "{\"call_ids\": ["
        var i = 0
        while (i < idCallsToDelete.count)
        {
            data += "\"\(idCallsToDelete[i])\""
            if i != idCallsToDelete.count - 1 // not last
            {
                data += ","
            }
            i += 1
        }
        data += "]}"
        let postData = NSData(data: data.data(using: String.Encoding.utf8)!)
        
        doRequest(httpMethod: "DELETE", sufixUrl : outgoingCallUrl, dataBody: postData,
                  success : {(data) -> () in
                    delegate.success(data: nil)
        }, fail : {(err) -> () in
            delegate.fail(msgError: err)
        })
    }
    
    func getMevo(delegate : APIDelegate)
    {
        doRequest(httpMethod: "GET", sufixUrl : mevoUrl, dataBody: nil,
                  success : {(data) -> () in
                    
                    var mevo : [Mevo] = []
                    if let datas = data["datas"] as? [[String: Any]] {
                        
                        for data in datas
                        {
                            mevo.append(Mevo(id: data["id"] as! String,
                                                    number: data["caller_number"] as? String,
                                                    duration: data["duration"] as! Double,
                                                    date: Date(timeIntervalSince1970 : data["date"] as! Double),
                                                    isSeen: data["seen"] as! Bool))
                        }
                    }
                    delegate.success(data: mevo as [AnyObject] )
                    
        }, fail : {(err) -> () in
            delegate.fail(msgError: err)
        })
    }
    
    func delMevo(delegate : APIDelegate, idMevoToDelete : [String])
    {
        var data = "{\"message_ids\": ["
        var i = 0
        while (i < idMevoToDelete.count)
        {
            data += "\"\(idMevoToDelete[i])\""
            if i != idMevoToDelete.count - 1 // not last
            {
                data += ","
            }
            i += 1
        }
        data += "]}"
        let postData = NSData(data: data.data(using: String.Encoding.utf8)!)
        
        doRequest(httpMethod: "DELETE", sufixUrl : mevoUrl, dataBody: postData,
                  success : {(data) -> () in
                    delegate.success(data: nil)
        }, fail : {(err) -> () in
            delegate.fail(msgError: err)
        })
    }
    
    func getMevoData(delegate : APIDelegateRawData, idMevo : String)
    {
        let data = "{\"message_id\": \"\(idMevo)\"}"
        let postData = NSData(data: data.data(using: String.Encoding.utf8)!)
        
        doRequestGetRaw(httpMethod: "POST", sufixUrl : MevoDataUrl, dataBody: postData,
                        success : {(data : Data?) -> () in
                   
                    delegate.success(data: data)
                    
        }, fail : {(err) -> () in
            delegate.fail(msgError: err)
        })
    }

    
    func disconnect()
    {
        /*delegateGetIncomingCall =  nil
        delegateMevo = nil
        delegateConnect = nil*/
        token = nil
    }

}



