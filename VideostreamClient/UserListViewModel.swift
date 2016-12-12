import Foundation
import Moya
import NSObject_Rx
import RxSwift

protocol UserListable: Pagintaionable {
    var endOfUsers: Variable<Bool> { get set }
    var numberOfUsers: Int { get }
    var updatedUserIndexes: VariablePublish<Array<IndexPath>> { get set }
    
    func userAtIndexPath(_ indexPath: IndexPath) -> User
}

class UserListViewModel: NSObject, ListReqestable, UserListable, ProfileSampleViewModelable {
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
    
    init(provider: RxMoyaProvider<StreamAPI>, page: Int = 1, pageSize: Int = 20){
        
        self.provider = provider
        self.pageSize = pageSize
        self.page = page
        
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
    
    func userAtIndexPath(_ indexPath: IndexPath) -> User {
        return elements[indexPath.row]
    }
    
    func profileSampleViewModelForIndexPath(_ indexPath: IndexPath) -> ProfileSampleViewModel?{
        
        if indexPath.count < numberOfUsers {
            return ProfileSampleViewModel(user: userAtIndexPath(indexPath))
        }
        
        return .none
    }

}

class LiveFollowingViewModel: UserListViewModel {
    
    override internal var endPoint: StreamAPI{
        return .liveFollowing(page: page, pageSize: pageSize)
    }
    
}

class LiveTopViewModel: UserListViewModel {
    
    override internal var endPoint: StreamAPI{
        return .liveTop(page: page, pageSize: pageSize)
    }
    
}
