import Quick
import Nimble
import RxSwift
import Moya

@testable
import VideostreamClient

class UserListViewModelSpec: QuickSpec {
    
    override func spec() {
        var subject: MockUserListViewModel!
        
        var disposeBag: DisposeBag!
        
        beforeEach {
            
            let provider = RxMoyaProvider<StreamAPI>(stubClosure: MoyaProvider.delayedStub(0.1))
            subject = MockUserListViewModel(provider: provider)
            
            disposeBag = DisposeBag()

        }
        
        describe("profileSampleViewModel(forIndex: IndexPath)"){
            it("return an profile sample cell view Model with proper user"){
                var id: String?
                var viewModel: ProfileSampleViewModel?
                
                subject.loadCurrentPage()
                
                waitUntil { done in
                    subject.updatedUserIndexes.asObservable().subscribe(onNext:{ e in
                        
                        let index = e.randomElement()
                        
                        id = subject.userAtIndexPath(index!).id
                        
                        viewModel = subject.profileSampleViewModelForIndexPath(index!)
                        done()
                        
                    }).addDisposableTo(disposeBag)
                }
                
                expect(viewModel?.userId).to(equal(id))
            }
            
            context("when the index path is outside the bounds"){
                it("return .none"){
                    let viewModel = subject.profileSampleViewModelForIndexPath(IndexPath(row: 0, section: 0))
                    
                    expect(viewModel).to(beNil())
                }
            }
        }
        
    }
}

class MockUserListViewModel: UserListViewModel {
    
    override internal var endPoint: StreamAPI{
        return .liveFollowing(page: page, pageSize: pageSize)
    }
}
