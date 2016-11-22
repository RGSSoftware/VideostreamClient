//
//  LoginViewController.swift
//  TodoClient
//
//  Created by PC on 10/7/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: AnyObject) {
        
        let parameters: Parameters = [
            "username": usernameTextField.text!,
            "password": PasswordTextField.text!
        ]
        
        
        
        Alamofire.request(ConfigManger.shared["services"]["baseApiURL"].stringValue + "/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().response { (response) in
                if let error = response.error {
                    return print("error: \(error)")
                }
                
                self.dismiss(animated: true, completion: nil)
            }
    }
    
}
