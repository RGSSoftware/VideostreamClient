import Moya
import NSObject_Rx
import RxSwift
import SwiftyJSON
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let provider = StubStreamProvider
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        guard let sVC = window?.rootViewController as? SplashViewController else { return false }
        sVC.provider = provider
        

        ConfigManger.jsonResourceName = "jsonConfig"
        
        return true
    }

}

