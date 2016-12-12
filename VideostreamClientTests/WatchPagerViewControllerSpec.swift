import Quick
import Nimble
import Nimble_Snapshots
import RxSwift
import Moya
import Foundation

@testable
import VideostreamClient

class WatchPagerViewControllerSpec: QuickSpec {
    
    override func spec() {
        var subject: UINavigationController!
        
        beforeEach {
            
            let provider = RxMoyaProvider<StreamAPI>(stubClosure: MoyaProvider.immediatelyStub)
            
            let nVC = R.storyboard.main.navPager_Screen()!
            
            guard let wpVC = nVC.topViewController as? WatchPagerViewController else { return }
            wpVC.provider = provider
            
            subject = nVC
            
        }
        
        it("looks right") {
            subject.loadViewProgrammatically()
            expect(subject).to(haveValidSnapshot())
        }
        
    }
    
}

