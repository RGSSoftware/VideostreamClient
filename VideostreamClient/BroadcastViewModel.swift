import Foundation
import Moya
import NSObject_Rx
import RxSwift
import RxCocoa

class BroadcastViewModel: NSObject {
    //input
    var startStreamDidSelect = PublishSubject<Void>()
    
    //output
    var steamKey = PublishSubject<String>()
    
    let provider: RxMoyaProvider<StreamAPI>
    
    init(provider: RxMoyaProvider<StreamAPI>){
        self.provider = provider
        
        super.init()
        
        self.startStreamDidSelect.flatMap({
            provider.request(.startBroadcast)
        }).mapJSON()
            .mapTo(object: User.self)
            .map{$0.stream.key}
            .bindTo(steamKey)
            .addDisposableTo(rx_disposeBag)
        
    }
}
