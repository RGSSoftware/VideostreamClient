import Alamofire
import Moya
import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    
    var provider: RxMoyaProvider<StreamAPI>!
    
//    lazy var viewModel: Profile = {
//        return SearchUsersViewModel(provider: self.provider!)
//    }()

    @IBOutlet weak var profileSampleView: ProfileSampleView!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var watchLiveButton: UIButton!
    
    var profileId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        provider.request(.users(id: profileId!)).subscribe{}.addDisposableTo(rx_disposeBag)
        
        let leftArrowButton = UIButton(image: R.image.navBackArrowImage())
        leftArrowButton?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        leftArrowButton?.addTarget(self, action: #selector(leftNavTap(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftArrowButton!)
        
        profileSampleView.profileImageButton.setImage(UIImage(named: ConfigManger.shared["Left_Nav_Screen"]["header"]["profileImage"]["placeholder"].stringValue), for: .normal)
        
        let baseURL = ConfigManger.shared["services"]["baseApiURL"].stringValue
        
        if let profileId = profileId {
            Alamofire.request(baseURL + "/users/\(profileId)", method: .get).responseJSON {[weak self] (response) in
                
                guard let strongSelf = self else { return }
                
                
                let data = response.result.value as! [String : Any]
                strongSelf.profileSampleView.profileNameLabel.text = "@\(data["username"] as! String)"
                if let streamStatus = data["streamStatus"] as? Bool{
                    
                    print("streamStatus: \(streamStatus)")
                    
                    if !streamStatus {
                        strongSelf.watchLiveButton.alpha = 0.3
                        strongSelf.watchLiveButton.isUserInteractionEnabled = false
                    }
                }

            }
            
            Alamofire.request(baseURL + "/user/isfollowing/\(profileId)", method: .get).responseJSON {[weak self] (response) in
                
                guard let strongSelf = self else { return }
                
                print(response.result.value)
                
                
                let data = response.result.value as! [String : Any]
                if let isfollowing = data["isFollowing"] as? Bool{
                    
                    print("isFollowing: \(isfollowing)")
                    
                    if isfollowing {
                        strongSelf.followButton.setImage(UIImage(named:"fullProfileImageSlec"), for: .normal)
                        strongSelf.followButton.setTitle("Following", for: .normal)
                    } else {
                        strongSelf.followButton.setImage(UIImage(named:"fullProfileImage"), for: .normal)
                        strongSelf.followButton.setTitle("Follow", for: .normal)


                    }
                }
            }
        }
    }
    
    func leftNavTap(_ id: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

}
