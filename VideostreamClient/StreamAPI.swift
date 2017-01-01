import Foundation
import Moya

let StreamProvider = RxMoyaProvider<StreamAPI>()
//let StubStreamProvider = RxMoyaProvider<StreamAPI>(stubClosure: MoyaProvider.delayedStub(2))
let StubStreamProvider = RxMoyaProvider<StreamAPI>(stubClosure: MoyaProvider.immediatelyStub)

enum StreamAPI {
    case login(password: String, username: String)
    case register(password: String, username: String, email: String)
    
    case liveTopUsers(page: Int, pageSize: Int)
    case searchUsers(q: String, page: Int, pageSize: Int)
    
    case user(id: String)
    
    case me
    case isCurrentUserFollowing(id: String)
    case currentUserFollowUser(id: String)
    case currentUserDeleteFollowing(id: String)
    case currentUserLiveFollowing(page: Int, pageSize: Int)
}


extension StreamAPI : TargetType {
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register"
            
        case .liveTopUsers:
            return "/users"
        case .searchUsers:
            return "/search/users"
            
        case .user(let id):
            return "/users/\(id)"
        
        case .me:
            return "/user"
        case .isCurrentUserFollowing(let id):
            return "/user/isfollowing/\(id)"
        case .currentUserFollowUser(let id),
            .currentUserDeleteFollowing(let id):
            return "/user/following/\(id)"
        case .currentUserLiveFollowing:
            return "/user/following"
        
        }
    }
    
    static var base: String { return "https://api.videostream.pixeljaw.com" }
    var baseURL: URL { return URL(string: StreamAPI.base)! }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let password, let username):
            return ["password": password, "username": username]
        case .register(let password, let username, let email):
            return ["password": password, "username": username, "email": email]
            
        case .liveTopUsers(let page, let pageSize):
            return ["page": page, "limit": pageSize]
            
        case .searchUsers(let q, let page, let pageSize):
            return ["q": q, "page": page, "limit": pageSize]
            
        case .currentUserLiveFollowing(let page, let pageSize):
            return ["streamStatus": 0, "page": page, "limit": pageSize]
        default:
            return nil
        }
        
    }
    
    public var task: Task {
        return .request
    }
    
    var method: Moya.Method {
        switch self {
        case .login,
             .register:
            return .post
        case .currentUserFollowUser:
             return .put
        case .currentUserDeleteFollowing:
            return .delete
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return stubbedResponse("Me")
        case .register:
            return stubbedResponse("Me")
            
        case .liveTopUsers(let page, _):
            if page == 1{
                return stubbedResponse("live_Top_x2")
            } else if (page == 2){
                return stubbedResponse("live_Top_x1")
            } else {
                return stubbedResponse("live_Top_x3")
            }
        case .searchUsers(_, let page, _):
            if page == 1{
                return stubbedResponse("live_Top_x1")
            } else if (page == 2){
                return stubbedResponse("live_Top_x2")
            } else {
                return stubbedResponse("live_Top_x3")
            }
            
        case .user:
            return stubbedResponse("User")
          
        case .me:
            return stubbedResponse("Me")
            
        case .isCurrentUserFollowing:
            return stubbedResponse("isFollowing")
        case .currentUserFollowUser,
             .currentUserDeleteFollowing:
            return stubbedResponse("currentUserFollowing")
            
        case .currentUserLiveFollowing(let page, _):
            if page == 1{
                return stubbedResponse("live_Top_x2")
            } else if (page == 2){
                return stubbedResponse("live_Top_x1")
            } else {
                return stubbedResponse("live_Top_x3")
            }
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .login,
             .register:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
        
    }
    
}


func stubbedResponse(_ filename: String) -> Data! {
    
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

