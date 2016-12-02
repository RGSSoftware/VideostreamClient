import UIKit
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import Action
import Artsy_UIButtons
import SVProgressHUD


class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: ARFlatButton!
    
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
        PasswordTextField.leftViewMode = .always
        PasswordTextField.leftView = dview
        
        loginButton.setTitle("dd", for: .disabled)

        loginButton.layer.cornerRadius = 3
        
        let usernameIsLongEnough = usernameTextField.rx.text
            .asObservable()
            .replaceNil(with: "")
            .map(isStringLengthAtLeast(length: 5))
        
        usernameIsLongEnough.bindNext{ (isHighlight) in
                imageView.isHighlighted = isHighlight
            }
        .addDisposableTo(rx_disposeBag)
        
        let passwordIsLongEnough = PasswordTextField.rx.text
            .asObservable()
            .replaceNil(with: "")
            .map(isStringLengthAtLeast(length: 6))
        
        passwordIsLongEnough.bindNext{ (isHighlight) in
            dimageView.isHighlighted = isHighlight
            }
            .addDisposableTo(rx_disposeBag)
        
        let formIsValid = [usernameIsLongEnough, passwordIsLongEnough].combineLatestAnd()
        
        let r = [true, false].reduceAnd()
        
        loginButton.rx.action = CocoaAction(enabledIf: formIsValid, workFactory: { [weak self] _ -> Observable<Void> in
            
            SVProgressHUD.show()
            
            print(self!.loginButton.isEnabled)
            let provider = StreamProvider
            let req = provider.request(.login(password: self!.PasswordTextField.text!, username: self!.usernameTextField.text!))
            req.subscribe(onNext: { (res) in
                    
                    SVProgressHUD.dismiss()
                
                    if res.statusCode == 200 {
                        self?.dismiss(animated: true){}
                    } else {
                        self?.showAuthenticationError()
                    }
                
                })
            .addDisposableTo((self?.rx_disposeBag)!)
            
            return req.map(void)
        })
    
    }
    
    func showAuthenticationError() {
        let alert = UIAlertController(title: "Login Error", message: "Password or username are invalid.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alert, animated: true){}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        usernameTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        usernameTextField.text = ""
        PasswordTextField.text = ""
    }
    
}
