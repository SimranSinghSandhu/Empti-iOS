//
//  LoginModal.swift
//  Test
//
//  Created by Simran Singh Sandhu on 05/01/21.
//

import UIKit

class LoginModal: Codable {
    
//    let status: Int
    let message: String
    let data: MyData
    init(dict: [String: Any]) {
        message = dict["message"] as! String
        data = dict["data"] as! MyData
    }
    
}

class MyData: Codable {
    
    let bearer_token: String
    
    init(dict: [String: Any]) {
        bearer_token = dict["bearer_token"] as! String
    }
    
}


struct ShopModal: Codable {
    let data: ShopData
}

struct ShopData: Codable {
    let shop_name: String
    let shop_address: String
    
    let containerDetail: [ContainerDetail]
}

struct ContainerDetail: Codable {
    let name: String
    let photo: String
    let available_container: Int
    let total_container: Int
}
