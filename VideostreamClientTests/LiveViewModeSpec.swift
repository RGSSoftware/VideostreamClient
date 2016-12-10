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
        
        describe("profileSampleViewModel"){
            
            it("username should be user.username"){
                
                var username: String?
                var viewModel: ProfileSampleViewModel?
                
                subject.loadCurrentPage()
                
                waitUntil { done in
                    subject.updatedUserIndexes.asObservable().subscribe(onNext:{ e in
                        
                        let index = e.randomElement()
                        
                        username = subject.userAtIndexPath(index!).username
                        
                        viewModel = subject.profileSampleViewModel(forIndex: index!)
                        done()
                        
                    }).addDisposableTo(disposeBag)
                }
                
                expect(viewModel?.username).to(equal(username))
                
            }
            
            it("imageURL should be URL"){
                
                var imageURL: URL?
                var viewModel: ProfileSampleViewModel?
                
                subject.loadCurrentPage()
                
                waitUntil { done in
                    subject.updatedUserIndexes.asObservable().subscribe(onNext:{ e in
                        
                        let index = e.randomElement()
                        
                        imageURL = URL(string: subject.userAtIndexPath(index!).imageUrl)
                        
                        viewModel = subject.profileSampleViewModel(forIndex: index!)
                        done()
                        
                    }).addDisposableTo(disposeBag)
                }
                
                expect(viewModel?.imageURL).to(equal(imageURL))
            }

        }
        
    }
}
