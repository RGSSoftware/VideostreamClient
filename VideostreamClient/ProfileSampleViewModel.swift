import Foundation

class ProfileSampleViewModel: NSObject {
    internal let user: User

    var userId: String{
        return user.id
    }
    
    var imageURL: URL?{
        return URL(string:user.imageUrl)
    }
    
    var username: String{
        return user.username
    }
    
    var isLive: Bool{
        return user.stream.isLive
    }
    
    init(user: User) {
        
        self.user = user
    }
}
