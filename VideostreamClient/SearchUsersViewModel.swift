import Foundation
import Moya
import RxSwift

protocol SearchUsersable: UserListable {
    
    func searchUsernamesWith(_ q: String)
}

class SearchUsersViewModel: UserListViewModel, SearchUsersable {
    
    override internal var endPoint: StreamAPI{
        return .searchUsers(q: q, page: page, pageSize: pageSize)
    }
    
    internal var q = ""
    
    internal var requestDisposable: Disposable?
    
    
    func searchUsernamesWith(_ q: String) {
        requestDisposable?.dispose()
        let elementsCount = elements.count
        let indexPaths = (0..<elementsCount).map { IndexPath(row: $0, section: 0) }
        elements.removeAll()
        deletedUserIndexes.value = indexPaths
        page = 0
        
        self.q = q
        
        loadCurrentPage()
    }
    
   override func loadCurrentPage() {
        requestDisposable = reqestPart()
        requestDisposable?.addDisposableTo(rx_disposeBag)
    }
}
