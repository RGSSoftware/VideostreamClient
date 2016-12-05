import Foundation
import Moya

let StreamAuthorizedProvider = RxMoyaProvider<StreamAuthorizedAPI>(plugins: [])

enum StreamAuthorizedAPI {
    case me
}

extension StreamAuthorizedAPI : TargetType {
    var path: String {
        switch self {
        case .me:
            return "/user"
        }
    }
    
    var base: String { return "https://api.videostream.pixeljaw.com" }
    var baseURL: URL { return URL(string: base)! }
    
    var parameters: [String: Any]? {
        switch self {
        default:
            return nil

        }
    }
    
    public var task: Task {
        return .request
    }
    
    var method: Moya.Method {
        switch self {
        
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .me:
            return stubbedResponse("Me")
            
        }
    }

}

let StreamProvider = RxMoyaProvider<StreamAPI>()
let StubStreamProvider = RxMoyaProvider<StreamAPI>(stubClosure: MoyaProvider.immediatelyStub)

enum StreamAPI {
    case login(password: String, username: String)
    case register(password: String, username: String, email: String)
    case liveTop(page: Int, pageSize: Int)
    case liveFollowing(page: Int, pageSize: Int)
}

extension StreamAPI : TargetType {
    var path: String {
        switch self {
        case .login(_, _):
            return "/login"
        case .register(_, _, _):
            return "/register"
        case .liveTop(_, _),
             .liveFollowing(_, _):
            return "/live/top"
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
        case .liveTop(let page, let pageSize),
             .liveFollowing(let page, let pageSize):
            return ["page": page, "limit": pageSize]
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
        case .liveTop,
             .liveFollowing:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return stubbedResponse("Me")
        case .register:
            return stubbedResponse("Me")
        case .liveTop(let page, _):
            if page == 1{
                return stubbedResponse("live_Top_x1")
            } else if (page == 2){
                return stubbedResponse("live_Top_x2")
            } else {
                return stubbedResponse("live_Top_x3")
            }
            
        case .liveFollowing(let page, _):
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
        case .liveTop,
             .liveFollowing:
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

