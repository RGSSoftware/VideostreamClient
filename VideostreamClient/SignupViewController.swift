//
//  SignupViewController.swift
//  VideostreamClient
//
//  Created by PC on 11/25/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import Action
import SVProgressHUD

class SignupViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView(frame: CGRect(x: 15, y: 5, width: 22, height: 20))
        let imageView =  UIImageView(image: R.image.navWatchLiveImage())
        imageView.highlightedImage = R.image.navGoLiveImage()
        imageView.contentMode = .scaleAspectFit
        
        imageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        view.addSubview(imageView)
        
        usernameTextField.leftViewMode = .always
        usernameTextField.leftView = view
        
        let dview = UIView(frame: CGRect(x: 15, y: 5, width: 22, height: 20))
        //        view.backgroundColor = .red
        let dimageView =  UIImageView(image: R.image.navWatchLiveImage())
        dimageView.highlightedImage = R.image.navGoLiveImage()
        dimageView.contentMode = .scaleAspectFit
        dimageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        //        imageView.backgroundColor = .green
        dview.addSubview(dimageView)
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = dview
        
        registerButton.setTitle("dd", for: .disabled)
        
        registerButton.layer.cornerRadius = 3
        
        let usernameIsLongEnough = usernameTextField.rx.text
            .asObservable()
            .replaceNil(with: "")
            .map(isStringLengthAtLeast(length: 5))
        
        usernameIsLongEnough.bindNext{ (isHighlight) in
            imageView.isHighlighted = isHighlight
            }
            .addDisposableTo(rx_disposeBag)
        
        let passwordIsLongEnough = passwordTextField.rx.text
            .asObservable()
            .replaceNil(with: "")
            .map(isStringLengthAtLeast(length: 6))
        
        passwordIsLongEnough.bindNext{ (isHighlight) in
            dimageView.isHighlighted = isHighlight
            }
            .addDisposableTo(rx_disposeBag)
        
        let emailIsValid = emailTextField.rx.text
            .asObservable()
            .replaceNil(with: "")
            .map(stringIsEmailAddress)
        
        emailIsValid.bindNext{ (isHighlight) in
//            dimageView.isHighlighted = isHighlight
            }
            .addDisposableTo(rx_disposeBag)
        
        let formIsValid = [usernameIsLongEnough, passwordIsLongEnough, emailIsValid].combineLatestAnd()
        
        registerButton.rx.action = CocoaAction(enabledIf: formIsValid, workFactory: { [weak self] _ -> Observable<Void> in
            
            print("yes")
//            SVProgressHUD.show()
            
            
            
            let provider = StreamProvider
            let req = provider.request(.login(password: self!.passwordTextField.text!, username: self!.usernameTextField.text!))
//            req.subscribe(onNext: { (res) in
//                
//                SVProgressHUD.dismiss()
//                
////                if res.statusCode == 200 {
////                    self?.dismiss(animated: true){}
////                } else {
////                    self?.showAuthenticationError()
////                }
//                
//            })
//                .addDisposableTo((self?.rx_disposeBag)!)
            
            return req.map(void)
        })
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }

}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
