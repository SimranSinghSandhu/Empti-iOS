//
//  ViewController.swift
//  Test
//
//  Created by Simran Singh Sandhu on 05/01/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func handleLoginBtn(_ sender: Any) {
    
        guard let email = emailTextField.text,
              let pass = passwordTextField.text else {return}
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "shopVC") as? ShopCollectionViewController
        
        NetworkManager.shared.postLoginCredentials(email: email, password: pass) { (result) in
            print("Got Result.")
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                
                vc?.bearerToken = data.data.bearer_token
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                
            }
            
        }
        
    }
}
