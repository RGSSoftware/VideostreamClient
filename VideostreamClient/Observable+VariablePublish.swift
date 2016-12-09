import Foundation
import RxSwift

extension ObservableType {
    public func bindTo(_ variable: VariablePublish<E>) -> Disposable {
        return subscribe { e in
            switch e {
            case let .next(element):
                variable.value = element
            case let .error(error):
                let error = "Binding error to variable: \(error)"
                print(error)
            case .completed:
                break
            }
        }
    }
}
