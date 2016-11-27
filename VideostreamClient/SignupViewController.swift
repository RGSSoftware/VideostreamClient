//
//  SignupViewController.swift
//  VideostreamClient
//
//  Created by PC on 11/25/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func register(_ sender: AnyObject) {
        
        let parameters: Parameters = [
            "username": usernameTextField.text!,
            "password": passwordTextField.text!,
            "email": emailTextField.text!
        ]
        
        Alamofire.request(ConfigManger.shared["services"]["baseApiURL"].stringValue + "/register", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().response { (response) in
            if let error = response.error {
                return print("error: \(error)")
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
