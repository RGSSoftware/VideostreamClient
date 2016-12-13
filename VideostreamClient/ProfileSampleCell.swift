import UIKit
import SnapKit

import RxSwift
import RxCocoa
import NSObject_Rx
import KGHitTestingViews

class ProfileSampleCell: UITableViewCell {
    
    typealias DownloadImageClosure = (_ url: URL?, _ imageView: UIImageView) -> ()
    typealias CancelDownloadImageClosure = (_ imageView: UIImageView) -> ()
    
    var downloadImage: DownloadImageClosure?
    var cancelDownloadImage: CancelDownloadImageClosure?

    var profileImageView: UIImageView!
    var profileNameLabel: UILabel!
    
    var watchButton: UIButton!
    var detailButton: UIButton!
    
    var reuseBag: DisposeBag?
    
    fileprivate var _watchPressed = PublishSubject<Void>()
    var watchPressed: Observable<Void> {
        return _watchPressed.asObservable()
    }
    
    fileprivate var _detailPressed = PublishSubject<Void>()
    var detailPressed: Observable<Void> {
        return _detailPressed.asObservable()
    }
    
    fileprivate var _preparingForReuse = PublishSubject<Void>()
    var preparingForReuse: Observable<Void> {
        return _preparingForReuse.asObservable()
    }
    
    var viewModel = PublishSubject<ProfileSampleViewModel>()
    func setViewModel(_ newViewModel: ProfileSampleViewModel) {
        self.viewModel.onNext(newViewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupSubscriptions()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelDownloadImage?(profileImageView)
        _preparingForReuse.onNext()
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        
        reuseBag = DisposeBag()
        guard let reuseBag = reuseBag else { return }
        
        viewModel.map { (viewModel) -> URL? in
            return viewModel.imageURL
            }.subscribe(onNext: { [weak self] url in
                 guard let imageView = self?.profileImageView else { return }
                self?.downloadImage?(url, imageView)
            }).addDisposableTo(reuseBag)
        
        viewModel.map { $0.username }
            .bindTo(profileNameLabel.rx.text)
            .addDisposableTo(reuseBag)
        
        viewModel.map { $0.isLive }
            .map{ !$0 }
            .bindTo(watchButton.rx.isHidden)
            .addDisposableTo(reuseBag)
    
        watchButton.rx.tap.subscribe(onNext: { [weak self] in
            self?._watchPressed.onNext()
        }).addDisposableTo(reuseBag)
        
        detailButton.rx.tap.subscribe(onNext: { [weak self] in
            self?._detailPressed.onNext()
        }).addDisposableTo(reuseBag)
    }
    
    func setup() {
        
        profileImageView = UIImageView()
        profileNameLabel = UILabel()
        
        watchButton = UIButton(type: .custom)
        watchButton.setImage(R.image.eye(), for: .normal)
        watchButton.imageView?.contentMode = .scaleAspectFit
        watchButton.setMinimumHitTestWidth(50, height: 0)
        
        detailButton = UIButton(type: .custom)
        detailButton.setImage(R.image.detailMenu(), for: .normal)
        detailButton.imageView?.contentMode = .scaleAspectFit
        detailButton.setMinimumHitTestWidth(50, height: 0)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileNameLabel)
        contentView.addSubview(watchButton)
        contentView.addSubview(detailButton)
        
        profileImageView.snp.makeConstraints{ make in
            
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(profileNameLabel.snp.left).offset(-16)
            
            make.width.equalTo(profileImageView.snp.height)
            make.height.equalTo(50)
            
            make.centerY.equalToSuperview()
            
        }
        
        profileNameLabel.snp.makeConstraints{ make in
            
            make.centerY.equalToSuperview()
            
        }
        
        watchButton.snp.makeConstraints{ make in
            
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            
            make.left.equalTo(profileNameLabel.snp.right).offset(8)
            make.right.equalTo(detailButton.snp.left).offset(-35)
            
            make.centerY.equalToSuperview()
            
            make.width.equalTo(32)
            
        }
        
        detailButton.snp.makeConstraints{ make in
            
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            
            make.right.equalToSuperview().offset(-24)
            
            make.centerY.equalToSuperview()
            
            make.width.equalTo(8)
            
        }
        
        layoutIfNeeded()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.masksToBounds = true
    }

}
