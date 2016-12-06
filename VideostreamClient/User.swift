import Foundation
import SwiftyJSON

enum StreamLiveStatus {
    case live
    case offline
}

struct User {
    let id: String
    
    let username: String
    let imageUrl: String
    
    let streamKey: String
    let streamLiveStatus: StreamLiveStatus
}

extension User: JSONAbleType {
    static func fromJSON(_ json: [String : Any]) -> User {
        let json = JSON(json)
        
        let id = json["id"].stringValue
        
        let username = json["username"].stringValue
        let imageUrl = json["imageUrl"].stringValue
        let streamKey = json["streamKey"].stringValue
        
        let status = json["streamStatus"].boolValue
        let liveStatus = status ? StreamLiveStatus.live : StreamLiveStatus.offline
        
        return User(id: id, username: username, imageUrl: imageUrl, streamKey: streamKey, streamLiveStatus: liveStatus)
    }
}
