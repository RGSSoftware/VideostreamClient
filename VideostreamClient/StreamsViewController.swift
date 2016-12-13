import Rswift
import SDWebImage
import SnapKit
import UIKit
import UIScrollView_InfiniteScroll
import XLPagerTabStrip


class StreamsViewController: UITableViewController, IndicatorInfoProvider {
    
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
        
        viewModel.loadCurrentPage()

        
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
        
        watch.subscribe(onNext:{[weak self] _ in
            
            self?.viewModel.showLiveStreamForIndexPath(indexPath)
            
        }).addDisposableTo(rx_disposeBag)
        
        detail.subscribe(onNext:{[weak self] _ in
            
            self?.viewModel.showDetailProfileForIndexPath(indexPath)
            
        }).addDisposableTo(rx_disposeBag)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.streamsViewController.from_Streams_to_Profile.identifier {
            let pVC = segue.destination as! ProfileViewController
            pVC.viewModel = sender as! ProfileViewModel
        }
    }
    
    func showDetails(forProfileViewModel profileViewModel: ProfileViewModel) {
        performSegue(withIdentifier: R.segue.streamsViewController.from_Streams_to_Profile.identifier, sender: profileViewModel)
        
        print("show detail for: \(profileViewModel.username)")
        
    }
    
    func showStream(forStreamViewModel streamViewModel: StreamViewModel) {
        
        print("show stream for:")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
