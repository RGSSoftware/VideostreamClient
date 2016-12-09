import Foundation
import Moya
import RxSwift

class SearchUsersViewModel: NSObject, ListReqestable, UserListViewModel {
    
    let provider: RxMoyaProvider<StreamAPI>
    
    internal var elements: [User] = []
    var numberOfUsers: Int {
        return elements.count
    }
    
    internal var insertedElementIndexes = VariablePublish<Array<IndexPath>>([])
    var updatedUserIndexes = VariablePublish<Array<IndexPath>>([])
    
    var deletedUserIndexes = VariablePublish<Array<IndexPath>>([])
    
    
    var endOfUsers = Variable<Bool>(false)
    
    internal var endPoint: StreamAPI{
        return .searchUsers(q: q, page: page, pageSize: pageSize)
    }
    
    internal var q = ""
    
    internal var pageSize: Int
    internal var page: Int
    
    internal var requestDisposable: Disposable?
    
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
    
    func searchUsernamesWith(_ q: String) {
        requestDisposable?.dispose()
        let elementsCount = elements.count
        let indexPaths = (0..<elementsCount).map { IndexPath(row: $0, section: 0) }
        elements.removeAll()
        deletedUserIndexes.value = indexPaths
        page = 1
        
        self.q = q
        
        loadCurrentPage()
    }
    
    func loadCurrentPage() {
        requestDisposable = reqestPart()
        requestDisposable?.addDisposableTo(rx_disposeBag)
    }
    
    func userAtIndexPath(_ indexPath: IndexPath) -> User {
        return elements[indexPath.row]
    }
}
