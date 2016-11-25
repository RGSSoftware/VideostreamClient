//
//  ProfileViewController.swift
//  VideostreamClient
//
//  Created by PC on 11/24/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit
import Alamofire

class MyProfileViewController: UIViewController {

    @IBOutlet weak var profileSampleView: ProfileSampleView!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    var dataStore: DataStore?
    
    var profileId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftArrowButton = UIButton(image: UIImage(named: "menu")!)
        leftArrowButton?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        leftArrowButton?.addTarget(self, action: #selector(leftNavTap(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftArrowButton!)
        
        profileSampleView.profileImageButton.setImage(UIImage(named: ConfigManger.shared["Left_Nav_Screen"]["header"]["profileImage"]["placeholder"].stringValue), for: .normal)
        
        let baseURL = ConfigManger.shared["services"]["baseApiURL"].stringValue
        
        Alamofire.request(baseURL + "/user", method: .get).responseJSON {[weak self] (response) in
            
            guard let strongSelf = self else { return }

            
             let data = response.result.value as! [String : Any]
            strongSelf.profileSampleView.profileNameLabel.text = "@\(data["username"] as! String)"
        }
        
        Alamofire.request(baseURL + "/user/following/count", method: .get).responseJSON {[weak self] (response) in
            
            guard let strongSelf = self else { return }
            
            
            let data = response.result.value as! [String : Any]
            print("count: \(data)")
            strongSelf.followingCountLabel.text = String(describing: data["count"] as! NSNumber)
        }
        
        dataStore = DataStore(baseURL: ConfigManger.shared["services"]["baseApiURL"].stringValue + "/user/following", fetchSize: 50)
        dataStore?.fetch(){ [weak self] (error, isSuccessful) in
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.reloadData()
        }
        
    }
    
    func leftNavTap(_ id: Any) {
        navigationController?.sideMenuViewController.presentLeftMenuViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "from_MyProfile_to_Profile" &&
            segue.destination is ProfileViewController {
            
            let pVC = segue.destination as! ProfileViewController
            pVC.profileId = sender as? String
            
        }
    }
}

extension MyProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore!.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileSampleCell
        
        let cellData = dataStore!.data[indexPath.row]
        
        cell.profileNameLabel?.text =  "@\(cellData["username"] as! String)"
        cell.profileImageView.image = UIImage(named: ConfigManger.shared["Left_Nav_Screen"]["header"]["profileImage"]["placeholder"].stringValue)
        
        return cell
    }
}

extension MyProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataStore!.data[indexPath.row]
        
        performSegue(withIdentifier: "from_MyProfile_to_Profile", sender: data["id"])
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
