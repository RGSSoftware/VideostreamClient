import Quick
import Nimble
import RxSwift
import Moya
import Foundation

@testable
import VideostreamClient

class LiveFollowingViewModelSpec: QuickSpec {
    
    override func spec() {
        var subject: LiveFollowingViewModel!
        
        beforeEach {
            
            let provider = RxMoyaProvider<StreamAPI>(stubClosure: MoyaProvider.delayedStub(0.1))
            subject = LiveFollowingViewModel(provider: provider)
            
        }
        
        describe("endPoint"){
            it("should be .liveFollowing"){
                let endPoint = subject.endPoint
                
                var isCorrect: Bool
                switch endPoint {
                case .liveFollowing:
                    isCorrect = true
                default:
                    isCorrect = false
                }
                
                expect(isCorrect).to(beTruthy())

            }
        }
    }
}
