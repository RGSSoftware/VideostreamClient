//
//  ProfileSampleCell.swift
//  VideostreamClient
//
//  Created by PC on 11/24/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit
import SnapKit

import RxSwift
import RxCocoa
import NSObject_Rx

class ProfileSampleCell: UITableViewCell {
    
    typealias DownloadImageClosure = (_ url: URL?, _ imageView: UIImageView) -> ()
    typealias CancelDownloadImageClosure = (_ imageView: UIImageView) -> ()
    
    var downloadImage: DownloadImageClosure?
    var cancelDownloadImage: CancelDownloadImageClosure?

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    
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
//        _preparingForReuse.onNext()
        setupSubscriptions()
        
        

    }
    
    func setupSubscriptions() {
        
        viewModel.map { (viewModel) -> URL? in
            return viewModel.imageURL
            }.subscribe(onNext: { [weak self] url in
                 guard let imageView = self?.profileImageView else { return }
                self?.downloadImage?(url, imageView)
            }).addDisposableTo(rx_disposeBag)
        
        viewModel.map { $0.username }
            .bindTo(profileNameLabel.rx.text)
            .addDisposableTo(rx_disposeBag)
    }
    
    func setup() {
        
        profileImageView = UIImageView()
        profileNameLabel = UILabel()
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileNameLabel)
        
        profileImageView.snp.makeConstraints{ make in
            
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(profileNameLabel.snp.left).offset(-16)
            
            make.width.equalTo(profileImageView.snp.height)
            make.height.equalTo(50)
            
            make.centerY.equalToSuperview()
            
        }
        
        profileNameLabel.snp.makeConstraints{ make in
            
            make.right.equalToSuperview().offset(8)
            
            make.centerY.equalToSuperview()
        }
        layoutIfNeeded()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.masksToBounds = true
    }

}
