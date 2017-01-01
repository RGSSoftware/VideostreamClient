//
//  ViewController.swift
//  mp4BackgroundView
//
//  Created by PC on 12/15/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import QuartzCore

class ViewController: UIViewController {

    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        
        
        let path = NSBundle.mainBundle().pathForResource("HappyApps_Background_MountainWater", ofType: "mp4")
        let url = NSURL(string: path!)!
        print(url)
        print(path)
        
        
        playVideo(url)
        
//        let videoView = FSVideoView(frame: view.bounds)
//        var controlFlag  = 0
//        videoView.filter = { image -> CIImage in
//            controlFlag++
//            if controlFlag % 10 > 5 {
//                let filter = CIFilter(name: "CIColorInvert", withInputParameters: ["inputImage":image])!
//                return filter.outputImage!
//            }
//            let filter = CIFilter(name: "CIColorClamp", withInputParameters: ["inputImage":image,"inputMinComponents":CIVector(CGRect: CGRect(x: 0.1, y: 0.1, width: 0.3, height: 0)),"inputMaxComponents":CIVector(CGRect: CGRectMake(0.5, 0.7, 0.9, 1))])!
//            return filter.outputImage!
//        }
//        view.addSubview(videoView)
//        view.sendSubviewToBack(videoView)
//        do {
//            try videoView.playVideos([url],fps: 25,loop: true)
//            videoView.play()
//        }catch _ {
//            
//        }
        
        
    }
    
    func playVideo(url: NSURL) {
        player = AVPlayer(URL: url)
        
//        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
//        layer.backgroundColor = UIColor.blackColor().CGColor
//        layer.frame = CGRectMake(0, 0, 300, 300)
//        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
//        self.view.layer.addSublayer(layer)
        
        
        let pVC = AVPlayerViewController()
        pVC.player = player
        
        addChildViewController(pVC)
        view.addSubview(pVC.view)
        pVC.view.frame = view.frame
        
        
        player.play()
    }

}

