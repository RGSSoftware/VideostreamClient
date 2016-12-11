import Foundation

protocol ProfileSampleViewModelable {
    func profileSampleViewModelForIndexPath(_ indexPath: IndexPath) -> ProfileSampleViewModel?
}
