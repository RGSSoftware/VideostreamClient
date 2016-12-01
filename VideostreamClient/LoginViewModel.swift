import Foundation
import RxSwift
import Result
import NSObject_Rx

struct LoginViewModel {
    let username = Variable("")
    let password = Variable("")
    
    func login() -> Observable<String> {
        
        return Observable.create { (observer) in
            let provider = StreamProvider
            let req = provider.request(.login(password: self.password.value, username: self.username.value))
            req.filterSuccessfulStatusCodes()
                .mapJSON()
                .subscribe(onNext: { (res) in
                    print("one r")
                    print(res)
                })
//                .addDisposableTo(rx_disposeBag)
            return Disposables.create()
            
            
        }
    }
}
