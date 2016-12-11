import Quick
import Nimble
import RxSwift
import Moya
import Foundation

@testable
import VideostreamClient

class LiveTopViewModelSpec: QuickSpec {
    
    override func spec() {
        var subject: LiveTopViewModel!
        
        beforeEach {
            
            let provider = RxMoyaProvider<StreamAPI>(stubClosure: MoyaProvider.delayedStub(0.1))
            subject = LiveTopViewModel(provider: provider)
            
        }
        
        describe("endPoint"){
            it("should be .liveTop"){
                let endPoint = subject.endPoint
                
                var isCorrect: Bool
                switch endPoint {
                case .liveTop:
                    isCorrect = true
                default:
                    isCorrect = false
                }
                
                expect(isCorrect).to(beTruthy())
                
            }
        }
    }
}
