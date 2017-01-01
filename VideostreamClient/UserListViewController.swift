import Rswift
import SDWebImage
import SnapKit
import UIKit
import UIScrollView_InfiniteScroll
import XLPagerTabStrip


class UserListViewController: UITableViewController, IndicatorInfoProvider {
    
    var viewModel: (UserListable & ProfileSampleViewModelable & DetailProfile & WatchLiveStream)!
    
    var downloadImage: ProfileSampleCell.DownloadImageClosure = { (url, imageView) -> () in
        if let url = url {
            imageView.sd_setImage(with: url,
               placeholderImage:R.image.profilePlaceholderImage(),
               options:[SDWebImageOptions.avoidAutoSetImage]){ [weak imageView] (image, _, _, _ ) in
                guard let strongImageView = imageView else { return }
                
                UIView.transition(with: strongImageView,
                                  duration:0.4,
                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                  animations: { strongImageView.image = image },
                                  completion: nil)
            }

        } else {
            imageView.image = R.image.profilePlaceholderImage()
        }
    }
    var cancelDownloadImage: ProfileSampleCell.CancelDownloadImageClosure = { (imageView) -> () in
        imageView.sd_cancelCurrentImageLoad()
    }
    
    var itemInfo: IndicatorInfo = "View"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.infiniteScrollIndicatorMargin = 40
        tableView.infiniteScrollTriggerOffset = 500
        
        tableView.addInfiniteScroll { [weak self] _ in
            guard let strongSelf = self else { return }
            
            strongSelf.viewModel.loadNextPage()
        }
        
        viewModel.endOfUsers.asObservable().bindNext{[weak self] isEnd in
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.setShouldShowInfiniteScrollHandler{ _ in return !isEnd}
        }.addDisposableTo(rx_disposeBag)
        
        viewModel.updatedUserIndexes.asObservable().bindNext{ [weak self] indexes in
            guard let strongSelf = self else { return }
        
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.insertRows(at: indexes, with: .automatic)
            strongSelf.tableView.endUpdates()
            
            strongSelf.tableView.finishInfiniteScroll()
            
             }.addDisposableTo(rx_disposeBag)
        
        viewModel.deletedUserIndexes.asObservable().bindNext{ [weak self] indexes in
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.deleteRows(at: indexes, with: .automatic)
            strongSelf.tableView.endUpdates()
            
            }.addDisposableTo(rx_disposeBag)
        
        viewModel.loadCurrentPage()
        
        viewModel.showDetailProfile.subscribe(onNext: { [weak self] viewModel in
        
            self?.performSegue(withIdentifier: R.segue.userListViewController.from_Streams_to_Profile.identifier, sender: viewModel)
            
            print("show detail for: \(viewModel.username)")
            
        }).addDisposableTo(rx_disposeBag)
        
        viewModel.showLiveStream.subscribe(onNext: { [weak self] viewModel in
            
//            self?.performSegue(withIdentifier: R.segue.userListViewController.from_Streams_to_Profile.identifier, sender: viewModel)
            
            print("show watch for: ")
            
        }).addDisposableTo(rx_disposeBag)

        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUsers
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.profileCell.identifier, for: indexPath) as! ProfileSampleCell
        
        cell.downloadImage = downloadImage
        cell.cancelDownloadImage = cancelDownloadImage
        
        cell.setViewModel(viewModel.profileSampleViewModelForIndexPath(indexPath)!)
        
        let watch = cell.watchPressed.takeUntil(cell.preparingForReuse)
        let detail = cell.detailPressed.takeUntil(cell.preparingForReuse)
        
        watch.map{indexPath}.subscribe { [weak self] (event) in
            switch event {
                case .next:
                    self?.viewModel.userWatchDidSelect.on(event)
                default:()
                }
            }.addDisposableTo(rx_disposeBag)
        
        detail.map{indexPath}.subscribe { [weak self] (event) in
            switch event {
                case .next:
                    self?.viewModel.userProfileDidSelect.on(event)
                default:()
                }
            }.addDisposableTo(rx_disposeBag)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.userListViewController.from_Streams_to_Profile.identifier {
            let pVC = segue.destination as! ProfileViewController
            pVC.viewModel = sender as! ProfileViewModel
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
