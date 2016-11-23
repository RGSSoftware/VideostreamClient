//
//  UIViewController+Exten.swift
//  VideostreamClient
//
//  Created by PC on 11/22/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit

private var screenIdAssociationKey: UInt8 = 0

extension UIViewController {
    var screenId: String? {
        get {
            return objc_getAssociatedObject(self, &screenIdAssociationKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &screenIdAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
