import Moya
import Rswift
import UIKit

class WatchPagerViewController: InstagramPagerViewController {
    
    var provider: RxMoyaProvider<StreamAPI>!
    
    override func viewDidLoad() {
        
        let child_1 = R.storyboard.main.streams_Screen()!
        child_1.itemInfo = "TOP"
        child_1.viewModel = LiveTopViewModel(provider: provider)
        child_1.viewModel.loadCurrentPage()
        
        
        let child_2 = R.storyboard.main.streams_Screen()!
        child_2.itemInfo = "FOLLOWING"
        child_2.viewModel = LiveFollowingViewModel(provider: provider)
        child_2.viewModel.loadCurrentPage()
        
        
        pageControllers = [child_1, child_2]
        
        let leftArrowButton = UIButton(image: R.image.menu())
        leftArrowButton?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        leftArrowButton?.addTarget(self, action: #selector(leftNavTap(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftArrowButton!)
        
        super.viewDidLoad()
        
    }

    func leftNavTap(_ id: Any) {
        sideMenuViewController.presentLeftMenuViewController()
    }

}
