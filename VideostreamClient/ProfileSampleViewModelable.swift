import Foundation

typealias ShowDetailsClosure = (ProfileViewModel) -> Void
typealias ShowLiveStreamClosure = (StreamViewModel) -> Void

protocol ProfileSampleViewModelable {
    func profileSampleViewModelForIndexPath(_ indexPath: IndexPath) -> ProfileSampleViewModel?
}

protocol DetailProfile {
    
    var showDetailProfile: ShowDetailsClosure { get set }
    
    func showDetailProfileForIndexPath(_ indexPath: IndexPath)
}

protocol WatchLiveStream {
    
    var showLiveStream: ShowLiveStreamClosure { get set }
    
    func showLiveStreamForIndexPath(_ indexPath: IndexPath)
}
