import Foundation

class ProfileSampleViewModel {
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
    
    init(user: User) {
        
        self.user = user
    }
}
