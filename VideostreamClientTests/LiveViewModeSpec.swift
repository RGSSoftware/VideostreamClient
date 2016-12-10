import Quick
import Nimble
import RxSwift
import Moya

@testable
import VideostreamClient

class LiveFollowingViewModelSpec: QuickSpec {
    
    override func spec() {
        var subject: LiveFollowingViewModel!
        
        var disposeBag: DisposeBag!
        
        beforeEach {
            
            let provider = RxMoyaProvider<StreamAPI>(stubClosure: MoyaProvider.delayedStub(0.1))
            subject = LiveFollowingViewModel(provider: provider)
            
            disposeBag = DisposeBag()
            
            
        }
        
    }
}
