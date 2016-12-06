import Foundation
import Moya
import RxSwift

protocol ListReqestable: class {
    associatedtype Element: JSONAbleType
    
    var provider: RxMoyaProvider<StreamAPI> { get }
    
    var elements: [Element] { get set }
    
    var endPoint: StreamAPI { get }
    
    var insertedElementIndexes: VariablePublish<Array<IndexPath>> {get set}
    
    func reqestPart() -> Disposable
}

extension ListReqestable {
    
    func reqestPart() -> Disposable {
        return provider.request(endPoint)
            .mapJSON()
            .mapTo(arrayOf: Element.self)
            .subscribe{[weak self] (event) in
                switch event {
                case .next(let e):
                    
                    let elementsCount = self!.elements.count
                    let (start, end) = (elementsCount, e.count + elementsCount)
                    let indexPaths = (start..<end).map { IndexPath(row: $0, section: 0) }
                    
                    self!.elements.append(contentsOf: e)
                    
                    self!.insertedElementIndexes.value = indexPaths
                default:()
                }
        }
    }
}
