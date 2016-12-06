import Rswift
import SDWebImage
import SnapKit
import UIKit
import UIScrollView_InfiniteScroll
import XLPagerTabStrip


class StreamsViewController: UITableViewController, IndicatorInfoProvider {
    
    var viewModel: LiveViewMode!
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileSampleCell
        
        let user = viewModel.userAtIndexPath(indexPath)
        cell.profileNameLabel.text = user.username
        
                cell.profileImageView!.sd_setImage(with: URL(string: user.imageUrl), placeholderImage:R.image.profilePlaceholderImage())
        
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
        cell.profileImageView.layer.masksToBounds = true
        
        return cell
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
