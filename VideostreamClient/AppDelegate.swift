import UIKit
import RxSwift
import NSObject_Rx
import Moya
import SwiftyJSON

protocol PagintaionReqestable {
    var pageSize: Int { get }
    var page: Int { get set }
    var endPoint: StreamAPI { get }
}

//extension PagintaionReqestable {
//    func requestNextPage() -> String{
////        page += 1
//        return reqest
//    }
//}

enum StreamLiveStatus {
    case live
    case offline
}

struct User {
    let username: String
    let imageUrl: String
    
    let streamKey: String
    let streamLiveStatus: StreamLiveStatus
}

extension User: JSONAbleType {
    static func fromJSON(_ json: [String : Any]) -> User {
        let json = JSON(json)
        
        let username = json["username"].stringValue
        let imageUrl = json["imageUrl"].stringValue
        let streamKey = json["imageUrl"].stringValue
        
        let status = json["streamStatus"].boolValue
        let liveStatus = status ? StreamLiveStatus.live : StreamLiveStatus.offline
        
        return User(username: username, imageUrl: imageUrl, streamKey: streamKey, streamLiveStatus: liveStatus)
    }
}


class WatchLiveViewMode: NSObject, PagintaionReqestable {
    let provider: RxMoyaProvider<StreamAPI>
    
    internal var streams: [User] = []
    var numberOfStreams: Int {
        return streams.count
    }
    
    var updatedContentIndexs = Variable<Array<IndexPath>>([])
    var endOfContent = Variable<Bool>(false)
    
    internal var pageSize: Int
    internal var page: Int
    internal var endPoint: StreamAPI{
        return .liveTop(page: page, pageSize: pageSize)
    }
    
    init(provider: RxMoyaProvider<StreamAPI>, pageSize: Int = 20) {
        self.provider = provider
        self.pageSize = pageSize
        self.page = 1
        
        updatedContentIndexs.value = [IndexPath(row: 1, section: 0)]
    }
    
    func loadCurrentPage() {
        provider.request(endPoint)
            .mapJSON()
            .mapTo(arrayOf: User.self)
            .subscribe{ [weak self] (event) in
                switch event {
                    case .next(let e):
                        
                        let streamsCount = self!.streams.count
                        let (start, end) = (streamsCount, e.count + streamsCount)
                        let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
                        
                        self!.streams.append(contentsOf: e)
                        
                        self?.updatedContentIndexs.value = indexPaths
                        
                    default:()
                }
            
            }.addDisposableTo(rx_disposeBag)
     
    }
    
    func loadNextPage() {
        
        page += 1
        loadCurrentPage()
        print(endPoint)
    
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let viewModel = WatchLiveViewMode(provider: StubStreamProvider)

    fileprivate(set) var provider = StreamAuthorizedProvider
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        viewModel.updatedContentIndexs
            .asObservable().subscribe{ event in
            print(event)
        }.addDisposableTo(rx_disposeBag)
        viewModel.loadCurrentPage()
//        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
//            
//        }
        
        let data = StreamAPI.liveTop(page: 1, pageSize: 20).sampleData
//        
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

