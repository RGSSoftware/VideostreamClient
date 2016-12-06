import Foundation
import RxSwift
import Moya

class ProfileViewModel: NSObject {
    
    let provider: RxMoyaProvider<StreamAPI>
    
    var user: User!
    var isFollowing: Observable<Bool>!
    
    
    init(provider: RxMoyaProvider<StreamAPI>, profileId: String) {
        
        self.provider = provider
        
        super.init()
        
//        reqestUser(profileId)
        reqestIsFollowing(profileId)
        
        
    }
    
    func reqestUser(_ id: String) {
        provider.request(.user(id: id))
            .mapJSON()
            .mapTo(object: User.self)
            .subscribe{[weak self] (event) in
                switch event {
                case .next(let e):
                    self!.user = e
                    
                default:()
                }
        }.addDisposableTo(rx_disposeBag)
    }
    
    func reqestIsFollowing(_ id: String){
        provider.request(.isCurrentUserFollowing(id: id))
            .mapJSON()
            .subscribe{[weak self] (event) in
                switch event {
                case .next(let e):
                    print("isFollowing")
                    print(e)
                default:()
                }
            }.addDisposableTo(rx_disposeBag)

    }
}
