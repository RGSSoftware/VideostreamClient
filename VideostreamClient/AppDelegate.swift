import UIKit
import RxSwift
import NSObject_Rx


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    fileprivate(set) var provider = StreamAuthorizedProvider
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ConfigManger.jsonResourceName = "jsonConfig"
        
//        let o = provider.request(.me)
//            .mapJSON()
//        
//            o.subscribe { event in
//
//                switch event {
//                case .next(let response):
//                    print("one r")
//                    print(response)
//                case .error(let error):
//                    print(error)
//                case .completed:
//                    print("one c")
//                }
//                
//                
//                
//            } .addDisposableTo(rx_disposeBag)
//        
//        o.subscribe { event in
//            
//            switch event {
//            case .next(let response):
//                print("two r")
//                print(response)
//            case .error(let error):
//                print(error)
//            case .completed:
//                print("two c")
//            }
//            
//            
//            
//            } .addDisposableTo(rx_disposeBag)
//        
//        
//        provider.request(.me)
//            .mapJSON()
//            .subscribe { event in
//            
//            switch event {
//            case .next(let response):
//                print("three r")
//                print(response)
//            case .error(let error):
//                print(error)
//            case .completed:
//                print("three c")
//            }
//            
//            
//            
//            } .addDisposableTo(rx_disposeBag)

    
        
        return true
    }

}

