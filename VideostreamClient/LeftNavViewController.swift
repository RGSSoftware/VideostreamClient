import Alamofire
import Moya
import SwiftyJSON
import UIKit

class LeftNavViewController: UIViewController {
    
    var provider: RxMoyaProvider<StreamAPI>!
    
    @IBOutlet weak var navProfileView: ProfileSampleView!

    let model = LeftNavModel.fromJSON(ConfigManger.shared["Left_Nav_Screen"])
    
    @IBOutlet weak var bodyTableView: UITableView!
    @IBOutlet weak var footerTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navProfileView.profileImageButton.setImage(R.image.profilePlaceholderImage(), for: .normal)
    }

    @IBAction func profileImageDidTap(_ sender: Any) {
        
        let contentVCScreenId = sideMenuViewController.contentViewController.screenId
        if contentVCScreenId == R.storyboard.main.profile_Nav_Screen.identifier {
            
            return sideMenuViewController.hideViewController()

        }
        
        let nVC = R.storyboard.main.profile_Nav_Screen()!
        nVC.screenId = R.storyboard.main.profile_Nav_Screen.identifier
        
        sideMenuViewController.setContentViewController(nVC, animated: true)
        sideMenuViewController.hideViewController()
        
    }
    
    func logoutCurrentUser() {
        let baseURL = ConfigManger.shared["services"]["baseApiURL"].stringValue
        Alamofire.request(baseURL + "/logout", method: .get).validate().response{[weak self] (response) in
            
            guard let strongSelf = self else { return }
            
            if let error = response.error{
                
            } else {
                
                if let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: baseURL)!){
                    for cookie in cookies {
                        HTTPCookieStorage.shared.deleteCookie(cookie)
                        
                    }
                }
                
                strongSelf.dismiss(animated: true, completion: nil)
            }
            
        }
    }
}

extension LeftNavViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == bodyTableView {
            
            return model.bodyCells.count
            
        } else {
            
            return model.footerCells.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.navCell.identifier, for: indexPath) as! NavCell
        
        var data: [NavCellModel]
        if tableView == bodyTableView {
            data = model.bodyCells
        } else {
            data = model.footerCells
        }
        
        cell.iconImageView.image = UIImage(named: data[indexPath.row].image)
        cell.titleLabel.text = data[indexPath.row].title
        
        if indexPath.row != (data.count - 1){
            cell.separatorView.isHidden = false
        }
        
        cell.separatorView.tintColor = cell.separatorView.backgroundColor
        cell.selectedBackgroundView = UIView()
        
        return cell
    }
    
}

extension LeftNavViewController: UITableViewDelegate {
    
    private func handleBodyTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = model.bodyCells[indexPath.row]
        
        let screenId = sideMenuViewController.contentViewController.screenId
        
        switch data.action {
        case .show(let screen):
            
            if screenId == nil ||
                screenId != screen {
                
                if screen == R.storyboard.main.broadcaster_Screen.identifier {
                    
                    let bVC = R.storyboard.main.broadcaster_Screen()!
                    present(bVC, animated: true, completion: nil)
                    
                } else if screen == R.storyboard.main.navPager_Screen.identifier {
                    
                    let nVC = R.storyboard.main.navPager_Screen()!
                    nVC.screenId = R.storyboard.main.navPager_Screen.identifier
                    
                    guard let wpVC = nVC.topViewController as? WatchPagerViewController else { return }
                    wpVC.provider = provider
                    
                    sideMenuViewController.setContentViewController(nVC, animated: true)
                    
                } else if screen == R.storyboard.main.search_Nav_Screen.identifier {
                    
                    let sVC = R.storyboard.main.search_Nav_Screen()!
                    sVC.screenId = R.storyboard.main.search_Nav_Screen.identifier
                    sideMenuViewController.setContentViewController(sVC, animated: true)
                }
            }

        default:()
        }
        
        sideMenuViewController.hideViewController()
        
    }
    
    private func handleFooterTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let data = model.footerCells[indexPath.row]
        
        let screenId = sideMenuViewController.contentViewController.screenId
        
        print(data.action)
        
        switch data.action {
        case .show(let screen):
            
            if screenId == nil ||
                screenId != screen {
                
//                if screen == R.storyboard.main.broadcaster_Screen.identifier {
//                    
//                    let bVC = R.storyboard.main.broadcaster_Screen()!
//                    present(bVC, animated: true, completion: nil)
//                    
//                } else if screen == R.storyboard.main.navPager_Screen.identifier {
//                    
//                    let nVC = R.storyboard.main.navPager_Screen()!
//                    nVC.screenId = R.storyboard.main.navPager_Screen.identifier
//                    sideMenuViewController.setContentViewController(nVC, animated: true)
//                    
//                } else if screen == R.storyboard.main.search_Nav_Screen.identifier {
//                    
//                    let sVC = R.storyboard.main.search_Nav_Screen()!
//                    sVC.screenId = R.storyboard.main.search_Nav_Screen.identifier
//                    sideMenuViewController.setContentViewController(sVC, animated: true)
//                }
            }
            
        case .code(let code):
            if code == "logout"{
                logoutCurrentUser()
            }
        }

        
        sideMenuViewController.hideViewController()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == bodyTableView {
            
            handleBodyTableView(tableView, didSelectRowAt: indexPath)
            
        } else {
            
            handleFooterTableView(tableView, didSelectRowAt: indexPath)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
