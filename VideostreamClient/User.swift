import Foundation
import SwiftyJSON

struct User {
    let id: String
    
    let username: String
    let imageUrl: String
    
    let stream: Stream
}

extension User: JSONAbleType {
    static func fromJSON(_ json: [String : Any]) -> User {
        let json = JSON(json)
        
        let id = json["id"].stringValue
        
        let username = json["username"].stringValue
        let imageUrl = json["imageUrl"].stringValue
        
        let streamKey = json["streamKey"].stringValue
        let status = json["streamStatus"].boolValue
        let stream = Stream(key: streamKey, isLive: status)
        
        return User(id: id, username: username, imageUrl: imageUrl, stream:stream)
    }
}
