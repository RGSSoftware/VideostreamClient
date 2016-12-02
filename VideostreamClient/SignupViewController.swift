import UIKit
import Alamofire
import RxSwift
import RxCocoa
import Action
import SVProgressHUD
import SwiftyJSON

class SignupViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.setTitle("dd", for: .disabled)
        registerButton.layer.cornerRadius = 3
        
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
        
        let emailImageView = UIImageView(image: R.image.email())
        emailImageView.highlightedImage = R.image.emailSle()
        emailImageView.contentMode = .scaleAspectFit
        
        emailTextField.leftViewMode = .always
        emailTextField.leftView = mapLeftView(emailImageView)
        
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
        
        let emailIsValid = emailTextField.rx.text
            .asObservable()
            .replaceNil(with: "")
            .map(stringIsEmailAddress)
        
        emailIsValid.bindNext{ (isHighlight) in
            emailImageView.isHighlighted = isHighlight
            }
            .addDisposableTo(rx_disposeBag)
        
        let formIsValid = [usernameIsLongEnough, passwordIsLongEnough, emailIsValid].combineLatestAnd()
        
        registerButton.rx.action = CocoaAction(enabledIf: formIsValid, workFactory: { [weak self] _ -> Observable<Void> in
            
            SVProgressHUD.show()
            
            let provider = StreamProvider
            let req = provider.request(.register(password: self!.passwordTextField.text!, username: self!.usernameTextField.text!, email: self!.emailTextField.text!))
            
            req.subscribe { event in
                SVProgressHUD.dismiss()
                
                switch event {
                case let .next(response):
                    
                    switch response.statusCode{
                    case 200 ... 299:
                        self?.dismiss(animated: true){}
                    case 400 ... 499:
                        let json = JSON(data: response.data)
                        self!.showAuthenticationError(message: json["message"].stringValue)
                    case 500 ... 599:
                        self!.showNetworkError()
                    default:()
                    }
                    
                case .error(_):
                    //log error
                    self!.showNetworkError()
                default:
                    break
                }
            }
            .addDisposableTo((self?.rx_disposeBag)!)
            
            return req.map(void)
        })
        
        
        
    }
    
    func showAuthenticationError(message: String) {
        let alert = UIAlertController(title: "Register Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alert, animated: true){}
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Network Error", message: "Please try later.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alert, animated: true){}
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        emailTextField.resignFirstResponder()
    }

}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
