import Foundation
import SwiftyJSON

struct UserModel: JSONAbleType {
    
    static func fromJSON(_ json: [String : Any]) -> UserModel {
        let json = JSON(json)
        return UserModel()
    }
}
