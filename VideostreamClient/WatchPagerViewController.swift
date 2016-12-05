import Moya
import Rswift
import UIKit

class WatchPagerViewController: InstagramPagerViewController {
    
    var provider: RxMoyaProvider<StreamAPI>!
    
    override func viewDidLoad() {
        
        let child_1 = R.storyboard.main.streams_Screen()!
        child_1.itemInfo = "TOP"
        child_1.dataStore = DataStore(baseURL: ConfigManger.shared["services"]["baseApiURL"].stringValue + "/user/following", fetchSize: 50, streamStatus: false)
        
        child_1.viewModel = LiveTopViewModel(provider: provider)
        
        
        let child_2 = R.storyboard.main.streams_Screen()!
        child_2.itemInfo = "FOLLOWING"
        child_2.dataStore = DataStore(baseURL: ConfigManger.shared["services"]["baseApiURL"].stringValue + "/user/following?streamStatus=1", fetchSize: 50, streamStatus: true)
        
        child_2.viewModel = LiveFollowingViewModel(provider: provider)
        
        
        pageControllers = [child_1, child_2]
        
        let leftArrowButton = UIButton(image: UIImage(named: "menu")!)
        leftArrowButton?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        leftArrowButton?.addTarget(self, action: #selector(leftNavTap(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftArrowButton!)
        
        super.viewDidLoad()
        
    }

    func leftNavTap(_ id: Any) {
        sideMenuViewController.presentLeftMenuViewController()
    }

}

protocol Callable{
    var first: String { get }
}

//protocol Person{
//    var last: String { get set }
//}

class Person {
    
    var last: String?
}

class Joe: Person, Callable {
    var first: String {
        return "Joe"
    }
}

