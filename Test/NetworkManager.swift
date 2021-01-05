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

        let parameters = ["email": email, "password": password]
        
        var request = URLRequest(url: URL(string: "https://empti.org/empti/public/api/login")!,timeoutInterval: Double.infinity)
        
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
        }
        request.httpMethod = "POST"
        request.httpBody = httpBody
        
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
        
        let parameters = ["outlet_id": "86"]
       
        var request = URLRequest(url: URL(string: "https://empti.org/empti/public/api/user/outletDetail")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
        }
        request.httpMethod = "POST"
        request.httpBody = httpBody

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
