import UIKit

import LFLiveKit

import Moya
import SwiftyJSON
import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Alamofire

class BroadcasterViewController: UIViewController {
        
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var provider: RxMoyaProvider<StreamAPI>!
    lazy var viewModel: BroadcastViewModel = {
        return BroadcastViewModel(provider: self.provider!)
    }()
    

    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .low1)
//        videoConfiguration?.autorotate = true
//        videoConfiguration?.videoSize = CGSize(width: 960, height: 540)
//        videoConfiguration?.outputImageOrientation = UIInterfaceOrientation.landscapeLeft
        
        
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)!
        session.delegate = self
        session.captureDevicePosition = .back
        session.preView = self.previewView
        return session
    }()
    
    var streamKey: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        session.running = true
        viewModel.steamKey.asObserver().subscribe(onNext:{[weak self] in
            let stream = LFLiveStreamInfo()
            stream.url = "\("rtmp://rtmpserver.pixeljaw.com/live/")\($0)"
            self?.session.startLive(stream)
            
        }).addDisposableTo(rx_disposeBag)
        
        Observable.just().bindTo(viewModel.startStreamDidSelect).addDisposableTo(rx_disposeBag)
        
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopLive()
    }
    

    func start() {
        
        let stream = LFLiveStreamInfo()
        stream.url = "\("rtmp://rtmpserver.pixeljaw.com/live/")\(viewModel.steamKey)"
        session.startLive(stream)
        
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}

extension BroadcasterViewController: LFLiveSessionDelegate {
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        switch state {
        case .error:
            statusLabel.text = "error"
        case .pending:
            statusLabel.text = "pending"
        case .ready:
            statusLabel.text = "ready"
        case.start:
            statusLabel.text = "start"
            
            
            
            let parameters: Parameters = [
                "streamStatus": true
            ]
            
            
            Alamofire.request(ConfigManger.shared["services"]["baseApiURL"].stringValue + "/user/streamstatus", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().response { (response) in
                if let error = response.error {
                    return print("error: \(error)")
                }
                
                print("did post streamstatus")
            }
            
            
        case.stop:
            statusLabel.text = "stop"
            
            
            let parameters: Parameters = [
                "streamStatus": false
            ]
            
            
            Alamofire.request(ConfigManger.shared["services"]["baseApiURL"].stringValue + "/user/streamstatus", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().response { (response) in
                if let error = response.error {
                    return print("error: \(error)")
                }
                
                print("did post streamstatus")
            }
        
        }
        
        
        
        print("stattttttt: \(state)")
        
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
         print("debugInfo: \(debugInfo)")
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("error: \(errorCode.rawValue)")
        
    }
}

