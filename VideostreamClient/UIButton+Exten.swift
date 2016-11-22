//
//  UIButton+Exten.swift
//  EL_LifestlyeV2
//
//  Created by PC on 10/23/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {

    public convenience init?(image: UIImage){
        
        self.init(type: UIButtonType.custom)
        
        self.setImage(image, for: .normal)
        
        self.contentMode = .scaleAspectFit
        self.imageView?.contentMode = .scaleAspectFit
        
        self.frame = CGRect(x: 0, y: 0, width: 30, height: 80)
    }

}
