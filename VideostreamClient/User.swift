import Foundation
import SwiftyJSON

struct User {
    let id: String
    
    let username: String
    let imageUrl: String
    
    let followerCount: Int
    
    let stream: Stream
}

extension User: JSONAbleType {
    static func fromJSON(_ json: [String : Any]) -> User {
        let json = JSON(json)
        
        let id = json["id"].stringValue
        
        let username = json["username"].stringValue
        let imageUrl = json["imageUrl"].stringValue
        
        let followerCount = json["followerCount"].intValue
        
        let streamKey = json["streamKey"].stringValue
        let status = json["streamStatus"].boolValue
        let stream = Stream(key: streamKey, isLive: status)
        
        return User(id: id,
                    username: username,
                    imageUrl: imageUrl,
                    followerCount: followerCount,
                    stream: stream)
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool{
        return lhs.id == rhs.id
    }
}
