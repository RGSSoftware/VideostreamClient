import UIKit
import IJKMediaFramework

class AudienceViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var viewModel: StreamViewModel!
    
    var player: IJKFFMoviePlayerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let urlString = "rtmp://rtmpserver.pixeljaw.com/live/" + viewModel.streamKey
        player = IJKFFMoviePlayerController(contentURLString: urlString, with: IJKFFOptions.byDefault())
        
        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player.view.frame = previewView.bounds
        previewView.addSubview(player.view)
    
        player.prepareToPlay()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.play()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player, queue: OperationQueue.main, using: { [weak self] notification in
            
            guard let this = self else {
                return
            }
            let state = this.player.loadState
            switch state {
            case IJKMPMovieLoadState.playable:
                this.statusLabel.text = "Playable"
            case IJKMPMovieLoadState.playthroughOK:
                this.statusLabel.text = "Playing"
            case IJKMPMovieLoadState.stalled:
                this.statusLabel.text = "Buffering"
            default:
                this.statusLabel.text = "Playing"
            }
        })

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.shutdown()
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
