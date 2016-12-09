import Foundation

protocol PagintaionReqestable: class {
    var pageSize: Int { get }
    var page: Int { get set }
    
    func loadCurrentPage()
    func loadNextPage()
}

extension PagintaionReqestable {
    func loadNextPage() {
        page += 1
        loadCurrentPage()
    }
}
