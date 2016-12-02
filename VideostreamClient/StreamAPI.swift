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

enum StreamAPI {
    case login(password: String, username: String)
    case register(password: String, username: String, email: String)
}

extension StreamAPI : TargetType {
    var path: String {
        switch self {
        case .login(_, _):
            return "/login"
        case .register(_, _, _):
            return "/register"
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
        }
        
    }
    
    public var task: Task {
        return .request
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return stubbedResponse("Me")
        case .register:
            return stubbedResponse("Me")
            
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        return JSONEncoding.default
    }
    
}


func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

