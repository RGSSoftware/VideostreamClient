import Moya
import NSObject_Rx
import RxSwift
import SwiftyJSON
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let provider = StubStreamProvider
    let viewModel = LiveFollowingViewModel(provider: StubStreamProvider)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        viewModel.updatedUserIndexes
//            .asObservable().subscribe{ [weak self] event in
//                switch event {
//                    case .next(let e):
//
//                        print(e.count)
//                        print(self!.viewModel.userAtIndexPath(e[3]))
//
//                    default: ()
//                }
//               
//        }.addDisposableTo(rx_disposeBag)
//        
//        viewModel.endOfUsers
//            .asObservable().subscribe(onNext: { isEnd in
//                print(isEnd)
//            }).addDisposableTo(rx_disposeBag)
//        viewModel.loadCurrentPage()
//        
//        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
//            self.viewModel.loadNextPage()
//            
//            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
//                self.viewModel.loadNextPage()
//            }
//        }
        
        guard let sVC = window?.rootViewController as? SplashViewController else { return false }
        sVC.provider = provider
        
        
        
//        StreamAPI.
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

