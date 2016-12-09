import Quick
import Nimble
import RxSwift
import Moya

@testable
import VideostreamClient

class LiveViewModeSpec: QuickSpec {
    
    override func spec() {
        var subject: LiveViewMode!
        
        var disposeBag: DisposeBag!
        
        beforeEach {
            
//            user = userModel()
            subject = MockLiveViewModel(provider: StubStreamProvider)
            
            disposeBag = DisposeBag()
            
        }
        
        it("liveProfileViewMode should be nil"){
        
        }
        
        it("liveProfileViewModel.provider should be provider"){
            
        }
    }
}


class MockLiveViewModel: LiveViewMode {
    
    override internal var endPoint: StreamAPI{
        return .liveFollowing(page: page, pageSize: pageSize)
    }
}
