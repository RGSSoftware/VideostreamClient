//
//  LeftNavViewController.swift
//  VideostreamClient
//
//  Created by PC on 11/19/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class LeftNavViewController: UIViewController {
    
    @IBOutlet weak var navProfileView: ProfileSampleView!

    let config = ConfigManger.shared["Left_Nav_Screen"]
    
    @IBOutlet weak var bodyTableView: UITableView!
    @IBOutlet weak var footerTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navProfileView.profileImageButton.setImage(UIImage(named: config["header"]["profileImage"]["placeholder"].stringValue), for: .normal)
    }

    @IBAction func profileImageDidTap(_ sender: Any) {
        
        let contentVCScreenId = sideMenuViewController.contentViewController.screenId
        if contentVCScreenId == "Profile_Nav_Screen" {
            return sideMenuViewController.hideViewController()

        }
        
        let pVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Profile_Screen") as! MyProfileViewController
        
        let nVC = UINavigationController(rootViewController: pVC)
        nVC.screenId = "Profile_Nav_Screen"
        

        sideMenuViewController.setContentViewController(nVC, animated: true)
        sideMenuViewController.hideViewController()

        
    }
    
    func logoutCurrentUser() {
        let baseURL = ConfigManger.shared["services"]["baseApiURL"].stringValue
        Alamofire.request(baseURL + "/logout", method: .get).validate().response{[weak self] (response) in
            
            guard let strongSelf = self else { return }
            
            if let error = response.error{
                
            } else {
                
                if let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: baseURL)!){
                    for cookie in cookies {
                        HTTPCookieStorage.shared.deleteCookie(cookie)
                        
                    }
                }
                
                strongSelf.dismiss(animated: true, completion: nil)
            }
            
        }
    }
}

extension LeftNavViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == bodyTableView {
            return 1
        } else if tableView == footerTableView {
            return 1
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == bodyTableView {
            return config["body"]["buttonStack"].arrayValue.count
        } else if tableView == footerTableView {
            return config["footer"]["buttonStack"].arrayValue.count
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NavCell", for: indexPath) as! NavCell
        
        var dataStack : [JSON]?
        if tableView == bodyTableView {
            dataStack = config["body"]["buttonStack"].array
        } else if tableView == footerTableView {
            dataStack = config["footer"]["buttonStack"].array
        }
        
        cell.iconImageView.image = UIImage(named: dataStack![indexPath.row]["image"].stringValue)
        cell.titleLabel.text = dataStack![indexPath.row]["title"].stringValue
        
        if indexPath.row == (dataStack!.count - 1){
            cell.separatorView.isHidden = true
        } else {
            cell.separatorView.isHidden = false
        }
        
        cell.separatorView.tintColor = cell.separatorView.backgroundColor
        cell.selectedBackgroundView = UIView()
        
        return cell
    }
    
}

extension LeftNavViewController : UITableViewDelegate{
    
    private func handleBodyTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = config["body"]["buttonStack"][indexPath.row]
        
        var VC : UIViewController!
        
        let screenId = sideMenuViewController.contentViewController.screenId
        
        if screenId == nil ||
            screenId != data["action"].stringValue {
            
            
            if data["action"] == "Broadcaster_Screen" {
                VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: data["action"].stringValue)
                present(VC, animated: true, completion: nil)
            } else {
                
                if screenId != "NavPager_Screen" {
                    if data["action"] == "LiveStreams_Screen" {
                        
                        let nVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavPager_Screen") as! UINavigationController
                        nVC.screenId = "NavPager_Screen"
                        
                        let ipVC = nVC.topViewController as! InstagramPagerViewController
                        
                        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Streams_Screen")as! StreamsViewController
                        child_1.itemInfo = "TOP"
                        child_1.dataStore = DataStore(baseURL: ConfigManger.shared["services"]["baseApiURL"].stringValue + "/user/following?streamStatus=0", fetchSize: 50)
                        
                        
                        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Streams_Screen")as! StreamsViewController
                        child_2.itemInfo = "FOLLOWING"
                        child_2.dataStore = DataStore(baseURL: ConfigManger.shared["services"]["baseApiURL"].stringValue + "/user/following?streamStatus=1", fetchSize: 50)
                        
                        
                        ipVC.pageControllers = [child_1, child_2]
                        
                        let leftArrowButton = UIButton(image: UIImage(named: "menu")!)
                        leftArrowButton?.setFrameSizeHeight((nVC.navigationBar.frame.size.height))
                        leftArrowButton?.addTarget(self, action: #selector(leftNavTap(_:)), for: .touchUpInside)
                        ipVC.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftArrowButton!)
                        
                        VC = nVC
                        
                    } else if data["action"] == "Search_Nav_Screen" {
                        let sVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Search_Nav_Screen")
                        VC = sVC
                    }
                    sideMenuViewController.setContentViewController(VC, animated: true)
                }
                
            }
            
        }
        
        sideMenuViewController.hideViewController()
        
    }
    
    private func handleFooterTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = config["footer"]["buttonStack"][indexPath.row]
        
        if let action = data["action"].dictionary{
            if let code = action["code"]?.string {
                if code == "logout"{
                    logoutCurrentUser()
                }
            }
        }
        
        sideMenuViewController.hideViewController()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == bodyTableView {
            handleBodyTableView(tableView, didSelectRowAt: indexPath)
        } else if tableView == footerTableView {
            handleFooterTableView(tableView, didSelectRowAt: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func leftNavTap(_ id: Any) {
        sideMenuViewController.presentLeftMenuViewController()
    }
//
//    func tableView(_ tableView: UITableView, deselectRow indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NavCell", for: indexPath) as! NavCell
//        
//        cell.iconImageView.backgroundColor = .clear
//        
//    }
//    
//    tabledes
    
    
    
    
}
