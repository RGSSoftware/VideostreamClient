import Foundation
import RxSwift
import Moya

class ProfileViewModel: NSObject {
    
    internal let provider: RxMoyaProvider<StreamAPI>
    
    internal let user: User
    
    var isFollowing = Variable<Bool>(false)
    
    var imageURL: URL?{
        return URL(string:user.imageUrl)
    }
    
    var username: String?{
        return user.username
    }
    
    var isLive: Bool?{
        return user.stream.isLive
    }
    
    init(provider: RxMoyaProvider<StreamAPI>, user: User) {
        
        self.provider = provider
        self.user = user
        
        super.init()
        
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
