import Moya
import NSObject_Rx
import RxSwift
import SwiftyJSON
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let provider = StubStreamProvider
//    let viewModel = ProfileViewModel(provider: StubStreamProvider, profileId: "ddld")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        guard let sVC = window?.rootViewController as? SplashViewController else { return false }
        sVC.provider = provider
        
//        self.viewModel.isFollowing.asObservable().subscribe{e in
//            print(e)
//            }.addDisposableTo(self.rx_disposeBag)
        
        
//        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
//            self.viewModel.isFollowing.asObservable().subscribe{e in
//                print(e)
//                }.addDisposableTo(self.rx_disposeBag)
//            
//            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (timer) in
//                self.viewModel.isFollowing.asObservable().subscribe{e in
//                    print(e)
//                    }.addDisposableTo(self.rx_disposeBag)
//            }
//        }
        
        
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

