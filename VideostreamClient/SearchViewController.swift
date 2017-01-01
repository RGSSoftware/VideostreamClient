import Alamofire
import Moya
import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    
    var provider: RxMoyaProvider<StreamAPI>!
    
    lazy var viewModel: SearchUsersViewModel = {
        return SearchUsersViewModel(provider: self.provider!)
    }()
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuNavButton()!)
        
        searchTextField.rx.text
            .filter { $0 != nil }
            .map { $0! }
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { $0.characters.count > 0 }
            .bindNext{[weak self] q in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.searchUsernamesWith(q)
            }.addDisposableTo(rx_disposeBag)

    }
    
    func leftNavTap(_ id: Any) {
        navigationController?.sideMenuViewController.presentLeftMenuViewController()
    }
    
    func cancelSearchTap(_ id: Any) {
        resignSearch()
    }
    
    func resignSearch() {
        searchTextField.resignFirstResponder()

        navigationItem.setLeftBarButton(UIBarButtonItem(customView: menuNavButton()!), animated: true)
    }
    
    func menuNavButton() -> UIButton?{
        let button = UIButton(image:R.image.menu())
        button?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        button?.addTarget(self, action: #selector(leftNavTap(_:)), for: .touchUpInside)
        
        return button
        
    }
    
    func searchCancelNavButton() -> UIButton? {
        let button = UIButton(image: R.image.searchCancelImage())
        button?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        button?.addTarget(self, action: #selector(cancelSearchTap(_:)), for: .touchUpInside)
        
        return button
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.searchViewController.from_Search_to_Profile.identifier &&
            segue.destination is ProfileViewController {
            
            let pVC = segue.destination as! ProfileViewController
            pVC.profileId = sender as? String
            
        } else if segue.destination is UserListViewController {
            let uVC = segue.destination as! UserListViewController
            uVC.viewModel = viewModel
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: searchCancelNavButton()!), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignSearch()
        return true
    }
}

