import Moya
import NSObject_Rx
import RxSwift
import SwiftyJSON
import UIKit
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let provider = StreamProvider
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        guard let sVC = window?.rootViewController as? SplashViewController else { return false }
        sVC.provider = provider
        

        SDImageCache.shared().store(R.image.one50x150(), forKey: "https://placehold.it/150x150", completion: nil)
        
        ConfigManger.jsonResourceName = "jsonConfig"
        
        return true
    }

}

