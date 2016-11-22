//
//  UIView+Exten.swift
//  EL_LifestlyeV2
//
//  Created by PC on 10/23/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setFrameSizeHeight(_ height: CGFloat) {
        var rect = self.frame
        rect.size.height = height
        self.frame = rect
    }
    
}
