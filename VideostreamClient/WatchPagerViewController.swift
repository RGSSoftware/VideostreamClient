import UIKit

class WatchPagerViewController: InstagramPagerViewController {
    
    override func viewDidLoad() {
        

        let child_1 = R.storyboard.main.streams_Screen()!
        child_1.itemInfo = "TOP"
        child_1.dataStore = DataStore(baseURL: ConfigManger.shared["services"]["baseApiURL"].stringValue + "/user/following", fetchSize: 50, streamStatus: false)
        
        
        let child_2 = R.storyboard.main.streams_Screen()!
        child_2.itemInfo = "FOLLOWING"
        child_2.dataStore = DataStore(baseURL: ConfigManger.shared["services"]["baseApiURL"].stringValue + "/user/following?streamStatus=1", fetchSize: 50, streamStatus: true)
        
        
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
