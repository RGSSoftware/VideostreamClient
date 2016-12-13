import Alamofire
import Moya
import RxSwift
import SDWebImage
import UIKit
import Artsy_UIButtons
import SVProgressHUD


class ProfileViewController: UIViewController {
    
    var provider: RxMoyaProvider<StreamAPI>!
    
    var viewModel: ProfileViewModel!

    @IBOutlet weak var profileSampleView: ProfileSampleView!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var watchLiveButton: ARFlatButton!
    
    var profileId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchLiveButton.layer.cornerRadius = 3
        watchLiveButton.setBorderColor(UIColor.darkGray, for: .disabled)
        
        let leftArrowButton = UIButton(image: R.image.navBackArrowImage())
        leftArrowButton?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftArrowButton!)
        
        viewModel.showSpinner.subscribe(onNext:{ showSpinner in
            showSpinner == true ? SVProgressHUD.show() : SVProgressHUD.dismiss()
        }).addDisposableTo(rx_disposeBag)
                
        leftArrowButton?.rx.tap
            .subscribe(onNext:{[weak self] in _ = self?.navigationController?.popViewController(animated: true)})
            .addDisposableTo(rx_disposeBag)
        
        profileSampleView.profileNameLabel.text = viewModel?.username
        
        if let imageURL = viewModel?.imageURL {
            profileSampleView.profileImageButton.sd_setImage(with: imageURL, for: .normal)
        } else {
            profileSampleView.profileImageButton.setImage(R.image.profilePlaceholderImage(), for: .normal)
        }
        
        viewModel.isFollowing.asObservable().bindTo(followButton.rx.isSelected).addDisposableTo(rx_disposeBag)
        followButton.rx.tap
            .subscribe(onNext: {[weak self] in self?.viewModel.followButtonDidTap()})
            .addDisposableTo(rx_disposeBag)
        
        watchLiveButton.isEnabled = viewModel.isLive

    }

}
