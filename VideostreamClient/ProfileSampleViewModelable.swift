import Foundation
import RxSwift
import RxCocoa

typealias ShowDetailsClosure = (ProfileViewModel) -> Void
typealias ShowLiveStreamClosure = (StreamViewModel) -> Void

protocol ProfileSampleViewModelable {
    func profileSampleViewModelForIndexPath(_ indexPath: IndexPath) -> ProfileSampleViewModel?
}

protocol DetailProfile {
    var userProfileDidSelect: PublishSubject<IndexPath> { get }
    var showDetailProfile: Observable<ProfileViewModel>! { get }
}

protocol WatchLiveStream {
    var userWatchDidSelect: PublishSubject<IndexPath> { get }
    var showLiveStream: Observable<StreamViewModel>! { get }
}
