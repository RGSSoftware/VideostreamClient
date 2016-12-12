import Quick
import Nimble
import RxSwift
import Moya

@testable
import VideostreamClient

import Foundation

class ProfileSampleViewModelSpec: QuickSpec {
    
    override func spec() {
        
        var subject: ProfileSampleViewModel!
        var user: User!
        
        beforeEach {
            
            user = userModel()
            
            subject = ProfileSampleViewModel(user: user)
        }
        
        describe("username"){
            it("returns the user's username"){
                expect(subject.username).to(equal(user.username))
            }
        }
        
        describe("isLive"){
            it("returns the user's steam's live status"){
                subject = ProfileSampleViewModel(user: userModel(isLive: true))
    
                expect(subject.isLive).to(equal(true))
    
                subject = ProfileSampleViewModel(user: userModel(isLive: false))
    
                expect(subject.isLive).to(equal(false))
            }
        }
        
        describe("imageURL"){
            it("returns the user's imageurl as URL"){
                
                let url = URL(string: user.imageUrl)
                
                expect(subject.imageURL).to(equal(url))
            }
        }
    }
}
