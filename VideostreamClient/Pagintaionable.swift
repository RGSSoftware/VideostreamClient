import Foundation

protocol Pagintaionable: class {
    var pageSize: Int { get }
    var page: Int { get set }
    
    func loadCurrentPage()
    func loadNextPage()
}

extension Pagintaionable {
    func loadNextPage() {
        page += 1
        loadCurrentPage()
    }
}
