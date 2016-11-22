//
//  ConfigStore.swift
//  EL_LifestlyeV2
//
//  Created by PC on 10/20/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import Foundation
import SwiftyJSON

class ConfigManger : NSObject{
    static let shared = ConfigManger()
    
    static var jsonResourceName: String?
    private var appData : JSON
    
    private override init() {
        
        let path = Bundle.main.path(forResource: ConfigManger.jsonResourceName!, ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        let json = JSON(data: jsonData! as Data)
        
        assert(json != JSON.null, "Json can not be nil")
        appData = json
        
    }
    
    subscript(key: JSONSubscriptType) -> JSON {
        get {
            return appData[key]
        }
    }

}
