//
//  HomeViewController.swift
//  VideostreamClient
//
//  Created by PC on 11/18/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import Alamofire
import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var streamKeyTextField: UITextField!
    
    let baseEndPoint = "https://api.videostream.pixeljaw.com"
    
    var user : [String : Any]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let leftArrowButton = UIButton(image: UIImage(named: "menu")!)
        leftArrowButton?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        leftArrowButton?.addTarget(self, action: #selector(leftNavTap(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftArrowButton!)
    }
    

    @IBAction func goLive(_ sender: Any) {
        
        Alamofire.request(baseEndPoint+"/user/streamkey", method: .delete).responseJSON { (response) in
        
            
            print("respones: \(response.result.value)")
            
            self.user = response.result.value as! [String : Any]?
            
            self.performSegue(withIdentifier: "to_Broadcaster", sender: self)
            
        }
        
    }
    
    func leftNavTap(_ id: Any) {
        navigationController?.sideMenuViewController.presentLeftMenuViewController()
    }

    @IBAction func watchStream(_ sender: Any) {
        
        self.performSegue(withIdentifier: "to_Stream", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("streamKey: \(user?["streamKey"])")
        
        if segue.identifier == "to_Broadcaster" &&
            segue.destination is BroadcasterViewController {
            let bVC = segue.destination as! BroadcasterViewController
            bVC.streamKey = user?["streamKey"] as! String
        }
        
//        if segue.identifier == "to_Stream" &&
//            segue.destination is AudienceViewController {
//            let bVC = segue.destination as! AudienceViewController
//            bVC.streamKey = streamKeyTextField.text
//        }
    }
    
}
