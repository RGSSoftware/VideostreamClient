import Foundation
import SwiftyJSON

struct Stream {
    
    let key: String
    let isLive: Bool
    
}

extension Stream: JSONAbleType {
    static func fromJSON(_ json: [String : Any]) -> Stream {
        let json = JSON(json)
        
        let key = json["streamKey"].stringValue
        let status = json["streamStatus"].boolValue
        
        return Stream(key: key, isLive: status)
    }
}
