import Foundation
import RxSwift
import Moya

class MyProfileSampleViewModel: NSObject {
    
    internal var user: User!
    
    internal let provider: RxMoyaProvider<StreamAPI>
    
    fileprivate var _username = Variable<String>("")
    var username: Observable<String> {
        return _username.asObservable()
    }
    
    fileprivate var _imageURL = Variable<String>("")
    var imageURL: Observable<URL?> {
        return _imageURL.asObservable().map{URL(string: $0)}
    }
    
    fileprivate var _showSpinner = Variable<Bool>(false)
    var showSpinner: Observable<Bool> {
        return _showSpinner.asObservable()
    }
    
    init(provider: RxMoyaProvider<StreamAPI>) {
        
        self.provider = provider
        
        super.init()
        
        reqestCurrentUser()
    }
    
    func reqestCurrentUser(){
        _showSpinner.value = true
        let req = provider.request(.me)
        
        
       let user = req.mapJSON()
            .mapTo(object: User.self)
        
        user.subscribe(onNext:{[weak self] in
            self?.user = $0})
        .addDisposableTo(rx_disposeBag)
        
        user.map{$0.imageUrl}.bindTo(_imageURL).addDisposableTo(rx_disposeBag)
        user.map{$0.username}.bindTo(_username).addDisposableTo(rx_disposeBag)
        
        req.map{ _ in false }.bindTo(_showSpinner).addDisposableTo(rx_disposeBag)
        
    }
}
