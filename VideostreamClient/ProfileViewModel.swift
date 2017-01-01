import Foundation
import RxSwift
import Moya

class ProfileViewModel: ProfileSampleViewModel {
    
    internal let provider: RxMoyaProvider<StreamAPI>
    
    var isFollowing = Variable<Bool>(false)
    
    fileprivate var _showSpinner = Variable<Bool>(false)
    var showSpinner: Observable<Bool> {
        return _showSpinner.asObservable()
    }
    
    init(provider: RxMoyaProvider<StreamAPI>, user: User) {
        
        self.provider = provider
        
        super.init(user: user)
        
        reqestIsFollowing(user.id)
        
    }
    
    func followButtonDidTap() {
        _showSpinner.value = true
        
        
        let req: Observable<Response>
        
        if isFollowing.value {
            req = provider.request(.currentUserDeleteFollowing(id: user.id))
        } else {
            req = provider.request(.currentUserFollowUser(id: user.id))
        }
            
            req.filterStatusCode(200)
            .subscribe(onNext:{ [weak self] _ in
                
                self?.isFollowing.value = self?.isFollowing.value == true ? false : true
                
        }).addDisposableTo(rx_disposeBag)
        
        req.map{ _ in false }.bindTo(_showSpinner).addDisposableTo(rx_disposeBag)
    }
    
    func reqestIsFollowing(_ id: String){
        _showSpinner.value = true
        let req = provider.request(.isCurrentUserFollowing(id: id))
            
            
            req.mapJSON()
            .map{ json -> Bool in
                
                if let dict = json as? [String: AnyObject],
                    let isFollowing = dict["isFollowing"] as? Bool{
                    return isFollowing
                }
                
                return false
                
            }.bindTo(isFollowing).addDisposableTo(rx_disposeBag)
        
        req.map{ _ in false }.bindTo(_showSpinner).addDisposableTo(rx_disposeBag)

    }
}
