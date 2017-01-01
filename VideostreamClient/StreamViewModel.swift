import Foundation
import Moya
import NSObject_Rx
import RxSwift
import RxCocoa

class StreamViewModel {
    let provider: RxMoyaProvider<StreamAPI>
    
    let streamKey: String
    
    internal let user: User
    init(provider: RxMoyaProvider<StreamAPI>, user: User){
        self.provider = provider
        self.user = user
        self.streamKey = user.stream.key
        
    }
}
