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
import RxSwift
import RxCocoa



class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    var formIsValid = Variable(false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView(frame: CGRect(x: 15, y: 5, width: 22, height: 20))
//        view.backgroundColor = .red
        let imageView =  UIImageView(image: R.image.navWatchLiveImage())
        imageView.highlightedImage = R.image.navGoLiveImage()
        imageView.contentMode = .scaleAspectFit

        imageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
//        imageView.backgroundColor = .green
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
        PasswordTextField.leftViewMode = .always
        PasswordTextField.leftView = dview
        
        
        let usernameIsLongEnough = usernameTextField
            .rx.text
            .asObservable()
            .replaceNil(with: "")
            .map(isStringLengthAtLeast(length: 5))
        
        usernameIsLongEnough.bindNext{ (isHighlight) in
                imageView.isHighlighted = isHighlight
            }
        .addDisposableTo(rx_disposeBag)
        
        let passwordIsLongEnough = PasswordTextField
            .rx.text
            .asObservable()
            .replaceNil(with: "")
            .map(isStringLengthAtLeast(length: 6))
        
        passwordIsLongEnough.bindNext{ (isHighlight) in
            dimageView.isHighlighted = isHighlight
            }
            .addDisposableTo(rx_disposeBag)
        
        [usernameIsLongEnough, passwordIsLongEnough].combineLatestAnd()
            .bindTo(formIsValid)
            .addDisposableTo(rx_disposeBag)
        
        
        let r = [true, false].reduceAnd()
        
        print(r)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func login(_ sender: AnyObject) {
        
        if formIsValid.value {
            print("all good")
        } else {
            print("somethings wrong")
        }
        
//        let provider = StreamProvider
//        let req = provider.request(.login(password: PasswordTextField.text!, username: usernameTextField.text!))
//        req.filterSuccessfulStatusCodes()
//            .mapJSON()
//            .subscribe(onNext: { (res) in
//                print("one r")
//                print(res)
//            })
//        .addDisposableTo(rx_disposeBag)
//        
//        req.filterStatusCode(400)
//            .mapJSON()
//            .subscribe(onNext: { (res) in
//                print("error")
//                print(res)
//            })
//            .addDisposableTo(rx_disposeBag)
    }
    
}
