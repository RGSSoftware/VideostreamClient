import Foundation
import Moya
import RxSwift

enum StreamClientError: String {
    case couldNotParseJSON
    case notLoggedIn
    case missingData
}

extension StreamClientError: Swift.Error { }

extension Observable {

    typealias Dictionary = [String: AnyObject]

    /// Get given JSONified data, pass back objects
    func mapTo<B: JSONAbleType>(object classType: B.Type) -> Observable<B> {
        return self.map { json in
            guard let dict = json as? Dictionary else {
                throw StreamClientError.couldNotParseJSON
            }

            return B.fromJSON(dict)
        }
    }

    /// Get given JSONified data, pass back objects as an array
    func mapTo<B: JSONAbleType>(arrayOf classType: B.Type) -> Observable<[B]> {
        
        
        return self.map { json in
            guard let array = json as? [AnyObject] else {
                throw StreamClientError.couldNotParseJSON
            }

            guard let dicts = array as? [Dictionary] else {
                throw StreamClientError.couldNotParseJSON
            }

            return dicts.map { B.fromJSON($0) }
        }
    }

}
