//
//  NetworkManager.swift
//  Test
//
//  Created by Simran Singh Sandhu on 05/01/21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func postLoginCredentials(email: String, password: String, completion: @escaping(Result<LoginModal, Error>) -> ()) {

        //reactnative@test.com
        //Test@1234
        let parameters = [
          [
            "key": "email",
            "value": email,
            "type": "text"
          ],
          [
            "key": "password",
            "value": password,
            "type": "text"
          ]] as [[String : Any]]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
//        let error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
              body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://empti.org/empti/public/api/login")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))

            return
          }
            
            let decoder = JSONDecoder()

            do {
                let result = try decoder.decode(LoginModal.self, from: data)
                print(result.message)
                print(result.data.bearer_token)
                
                completion(.success(result))
                
            } catch {
                print(error)
            }
            
            
        }
        task.resume()
    }
    
    func getShopDetails(token: String, completion: @escaping(Result<ShopModal, Error>) -> ()) {
        
        let parameters = [
          [
            "key": "outlet_id",
            "value": "86",
            "type": "text"
          ]] as [[String : Any]]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
//        var error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
              body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://empti.org/empti/public/api/user/outletDetail")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
//          print(String(data: data, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
//            print(String(data: data, encoding: .utf8)!)
            do {
                let result = try decoder.decode(ShopModal.self, from: data)
                
                print(result.data.shop_name)
                completion(.success(result))
                
            } catch {
                print(error)
            }
            
            
        }

        task.resume()
        
    }
 
    
}
