import Foundation
import Moya
import NSObject_Rx
import RxSwift
import RxCocoa

class StreamViewModel {
    let provider: RxMoyaProvider<StreamAPI>
    internal let user: User
    init(provider: RxMoyaProvider<StreamAPI>, user: User){
        self.provider = provider
        self.user = user
        
    }
}
