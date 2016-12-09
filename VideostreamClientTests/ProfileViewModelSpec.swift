import Quick
import Nimble
import RxSwift
import Moya

@testable
import VideostreamClient

class ProfileViewModelSpec: QuickSpec {

    override func spec() {
        var subject: ProfileViewModel!
        var user: User!
        
        var disposeBag: DisposeBag!
        
        beforeEach {
            
            user = userModel()
            subject = ProfileViewModel(provider: StubStreamProvider, user: user)
            
            disposeBag = DisposeBag()
        
        }
        
        it("username should be user.username") {
            
            expect(subject.username).to(equal(user.username))
        }
        
        it("imageUrl should be uesr.imageUrl") {
            
            let url = URL(string: user.imageUrl)
            
            expect(subject.imageURL).to(equal(url))
        }
        
        it("isOnline should be user.status") {
            
            subject = ProfileViewModel(provider: StubStreamProvider, user: userModel(isLive: true))
            
            expect(subject.isLive).to(equal(true))
            
            subject = ProfileViewModel(provider: StubStreamProvider, user: userModel(isLive: false))
            
            expect(subject.isLive).to(equal(false))
            
        }
        
        it("isFollowing should update"){
            let provider = RxMoyaProvider<StreamAPI>(stubClosure: MoyaProvider.delayedStub(0.1))
            subject = ProfileViewModel(provider:provider, user:userModel())
            
            var initialStatus: Bool?
            var updatedStatus: Bool?
            
            waitUntil { done in
                subject.isFollowing.asObservable().subscribe(onNext:{ e in
                    if initialStatus == nil {
                        initialStatus = e
                    } else {
                        updatedStatus = e
                        done()
                    }
                }
                ).addDisposableTo(disposeBag)
            }
            
            expect(initialStatus).to(equal(false))
            expect(updatedStatus).toNot(beNil())
            
        }
        
    }
}

func userModel(isLive: Bool = false) -> User{
    
    let data = [
        "id": "id",
        "username": "bar",
        "imageUrl": "https://placehold.it/150x150",
        "streamKey": "123",
        "streamStatus": isLive
        
    ] as [String : Any]
    
    return User.fromJSON(data)
}
