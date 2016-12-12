import Foundation
import RxSwift
import Moya

class ProfileViewModel: ProfileSampleViewModel {
    
    internal let provider: RxMoyaProvider<StreamAPI>
    
    var isFollowing = Variable<Bool>(false)
    
    init(provider: RxMoyaProvider<StreamAPI>, user: User) {
        
        self.provider = provider
        
        super.init(user: user)
        
        reqestIsFollowing(user.id)
        
    }
    
    func reqestIsFollowing(_ id: String){
        provider.request(.isCurrentUserFollowing(id: id))
            .mapJSON()
            .map{ json -> Bool in
                
                if let dict = json as? [String: AnyObject],
                    let isFollowing = dict["isFollowing"] as? Bool{
                    return isFollowing
                }
                
                return false
                
            }.bindTo(isFollowing).addDisposableTo(rx_disposeBag)

    }
}
