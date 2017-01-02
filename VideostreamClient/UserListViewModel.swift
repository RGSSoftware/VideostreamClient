import Foundation
import Moya
import NSObject_Rx
import RxSwift
import RxCocoa

protocol UserListable: Pagintaionable {
    var endOfUsers: Variable<Bool> { get set }
    var numberOfUsers: Int { get }
    
    var updatedUserIndexes: VariablePublish<Array<IndexPath>> { get set }
    var deletedUserIndexes: VariablePublish<Array<IndexPath>> { get set }
    
    func userAtIndexPath(_ indexPath: IndexPath) -> User
}

class UserListViewModel: NSObject, ListReqestable, UserListable, ProfileSampleViewModelable, DetailProfile, WatchLiveStream {
    let provider: RxMoyaProvider<StreamAPI>
    
    internal var elements: [User] = []
    var numberOfUsers: Int {
        return elements.count
    }
    
    internal var insertedElementIndexes = VariablePublish<Array<IndexPath>>([])
    var updatedUserIndexes = VariablePublish<Array<IndexPath>>([])
    var deletedUserIndexes = VariablePublish<Array<IndexPath>>([])
    
    var endOfUsers = Variable<Bool>(true)
    
    internal var endPoint: StreamAPI{
        assert(false, "This method must be overriden by the subclass")
    }
    
    internal var pageSize: Int
    internal var page: Int
    
    //input
    var userWatchDidSelect = PublishSubject<IndexPath>()
    var userProfileDidSelect = PublishSubject<IndexPath>()
    
    //output
    var showDetailProfile: Observable<ProfileViewModel>!
    var showLiveStream: Observable<StreamViewModel>!
    
    init(provider: RxMoyaProvider<StreamAPI>, page: Int = 0, pageSize: Int = 20){
        
        self.provider = provider
        self.pageSize = pageSize
        self.page = page
        
        super.init()
        
        self.showDetailProfile = self.userProfileDidSelect.map({[weak self] indexPath in
            return ProfileViewModel(provider:self!.provider, user: self!.userAtIndexPath(indexPath))})
            .asObservable()
        
        self.showLiveStream = self.userWatchDidSelect.map({[weak self] indexPath in
            return StreamViewModel(provider:self!.provider, user: self!.userAtIndexPath(indexPath))})
            .asObservable()
        
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
    
    func userAtIndexPath(_ indexPath: IndexPath) -> User {
        return elements[indexPath.row]
    }
    
    func profileSampleViewModelForIndexPath(_ indexPath: IndexPath) -> ProfileSampleViewModel?{
        
        if indexPath.row < numberOfUsers {
            return ProfileSampleViewModel(user: userAtIndexPath(indexPath))
        }
        
        return .none
    }

}

class LiveFollowingViewModel: UserListViewModel {
    
    override internal var endPoint: StreamAPI{
        return .currentUserLiveFollowing(page: page, pageSize: pageSize)
    }
    
}

class LiveTopViewModel: UserListViewModel {
    
    override internal var endPoint: StreamAPI{
        return .liveTopUsers(page: page, pageSize: pageSize)
    }
    
}
