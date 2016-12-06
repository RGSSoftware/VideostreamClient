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
        
        tableView.infiniteScrollIndicatorMargin = 40
        tableView.infiniteScrollTriggerOffset = 500
        tableView.addInfiniteScroll { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.loadNextPage()
        }
        
        viewModel.endOfUsers.asObservable().bindNext{[weak self] isEnd in
            guard let strongSelf = self else { return }
            print(isEnd)
            strongSelf.tableView.setShouldShowInfiniteScrollHandler{ _ in return !isEnd}
            }.addDisposableTo(rx_disposeBag)
        
        viewModel.updatedUserIndexes.asObservable().bindNext{ [weak self] indexes in
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.insertRows(at: indexes, with: .automatic)
            strongSelf.tableView.endUpdates()
            
            strongSelf.tableView.finishInfiniteScroll()
            
            }.addDisposableTo(rx_disposeBag)
        
        viewModel.deletedUserIndexes.asObservable().bindNext{ [weak self] indexes in
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.deleteRows(at: indexes, with: .automatic)
            strongSelf.tableView.endUpdates()
            
            }.addDisposableTo(rx_disposeBag)
        
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

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.profileCell.identifier, for: indexPath) as! ProfileSampleCell
        
        let user = viewModel.userAtIndexPath(indexPath)
        
        cell.profileNameLabel?.text =  user.username
        cell.profileImageView.image = R.image.profilePlaceholderImage()
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resignSearch()
        
        let user = viewModel.userAtIndexPath(indexPath)
        
        performSegue(withIdentifier: R.segue.searchViewController.from_Search_to_Profile.identifier, sender: user.id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

