//
//  ProfileSampleCell.swift
//  VideostreamClient
//
//  Created by PC on 11/24/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit
import SnapKit

class ProfileSampleCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
    }

}
