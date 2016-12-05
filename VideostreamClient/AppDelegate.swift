import Moya
import NSObject_Rx
import RxSwift
import SwiftyJSON
import UIKit

protocol PagintaionReqestable {
    var pageSize: Int { get }
    var page: Int { get set }
}

enum StreamLiveStatus {
    case live
    case offline
}


protocol ListReqestable: class {
    associatedtype Element: JSONAbleType
    
    var provider: RxMoyaProvider<StreamAPI> { get }
    
    var elements: [Element] { get set }
    
    var endPoint: StreamAPI { get }
    
    var insertedElementIndexes: VariablePublish<Array<IndexPath>> {get set}
    
    func reqestPart() -> Disposable
}

extension ListReqestable {
    
    func reqestPart() -> Disposable {
        return provider.request(endPoint)
            .mapJSON()
            .mapTo(arrayOf: Element.self)
            .subscribe{[weak self] (event) in
                switch event {
                case .next(let e):
                    
                    let streamsCount = self!.elements.count
                    let (start, end) = (streamsCount, e.count + streamsCount)
                    let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
                    
                    self!.elements.append(contentsOf: e)
                    
                    self!.insertedElementIndexes.value = indexPaths
                default:()
                }
        }
    }
}


class LiveViewMode: NSObject, ListReqestable, PagintaionReqestable {

    let provider: RxMoyaProvider<StreamAPI>
    
    internal var elements: [User] = []
    var numberOfUsers: Int {
        return elements.count
    }
    
    internal var insertedElementIndexes = VariablePublish<Array<IndexPath>>([])
    var updatedUserIndexes = VariablePublish<Array<IndexPath>>([])

    
    var endOfUsers = Variable<Bool>(false)
    
    internal var endPoint: StreamAPI{
        assert(false, "This method must be overriden by the subclass")
    }
    
    internal var pageSize: Int
    internal var page: Int
    
    init(provider: RxMoyaProvider<StreamAPI>, pageSize: Int = 20) {
        
        self.provider = provider
        self.pageSize = pageSize
        self.page = 1
        
        super.init()
        
        let o = insertedElementIndexes
            .asObservable()
            
        o.bindTo(updatedUserIndexes).addDisposableTo(rx_disposeBag)
        
        o.map {
            $0.count != pageSize ? true : false
        }.bindTo(endOfUsers).addDisposableTo(rx_disposeBag)
        
    }
    
    func loadCurrentPage() {
        reqestPart().addDisposableTo(rx_disposeBag)
    }
    
    func loadNextPage() {
        page += 1
        loadCurrentPage()
    }
    
    func userAtIndexPath(_ indexPath: IndexPath) -> User {
        return elements[indexPath.row]
    }
}

class LiveFollowingViewModel: LiveViewMode {
    
    override internal var endPoint: StreamAPI{
        return .liveFollowing(page: page, pageSize: pageSize)
    }
}

class LiveTopViewModel: LiveViewMode {
    
    override internal var endPoint: StreamAPI{
        return .liveTop(page: page, pageSize: pageSize)
    }
}

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

