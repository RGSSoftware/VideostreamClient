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
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: ARFlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 3
        loginButton.setBorderColor(UIColor.darkGray, for: .disabled)
        
        let usernameImageView = UIImageView(image: R.image.profileUsername())
        usernameImageView.highlightedImage = R.image.profileUsernameSle()
        usernameImageView.contentMode = .scaleAspectFit
        
        usernameTextField.leftViewMode = .always
        usernameTextField.leftView = mapLeftView(usernameImageView)
        
        let passwordImageView = UIImageView(image: R.image.lock())
        passwordImageView.highlightedImage = R.image.lockSle()
        passwordImageView.contentMode = .scaleAspectFit
        
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = mapLeftView(passwordImageView)
        
        
        let usernameIsLongEnough = usernameTextField.rx.text
            .asObservable()
            .replaceNil(with: "")
            .map(isStringLengthAtLeast(length: 5))
        
        usernameIsLongEnough.bindNext{ (isHighlight) in
            usernameImageView.isHighlighted = isHighlight
            }
            .addDisposableTo(rx_disposeBag)
        
        let passwordIsLongEnough = passwordTextField.rx.text
            .asObservable()
            .replaceNil(with: "")
            .map(isStringLengthAtLeast(length: 6))
        
        passwordIsLongEnough.bindNext{ (isHighlight) in
            passwordImageView.isHighlighted = isHighlight
            }
            .addDisposableTo(rx_disposeBag)
        
        let formIsValid = [usernameIsLongEnough, passwordIsLongEnough].combineLatestAnd()
        
        loginButton.rx.action = CocoaAction(enabledIf: formIsValid, workFactory: { [weak self] _ -> Observable<Void> in
            
            SVProgressHUD.show()
            
            print(self!.loginButton.isEnabled)
            let provider = StreamProvider
            let req = provider.request(.login(password: self!.passwordTextField.text!, username: self!.usernameTextField.text!))
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
    
    func mapLeftView(_ containView: UIView) -> UIView {
        let view = UIView(frame: CGRect(x: 15, y: 5, width: 22, height: 20))
        containView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        view.addSubview(containView)
        return view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
}
