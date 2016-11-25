//
//  SerchViewController.swift
//  
//
//  Created by PC on 11/25/16.
//
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var searchTimer: Timer?
    
    @IBOutlet weak var tableView: UITableView!
    var data: [[String: Any]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        data = []
        for i in 0...50{
            let row = ["username": String(i)]
            data?.append(row)
        }
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuNavButton()!)
    }
    
    func leftNavTap(_ id: Any) {
        navigationController?.sideMenuViewController.presentLeftMenuViewController()
    }
    
    func cancelSearchTap(_ id: Any) {
        resignSearch()
    }
    
    func resignSearch() {
        searchTextField.resignFirstResponder()

        navigationItem.setLeftBarButton(UIBarButtonItem(customView: menuNavButton()!), animated: true)
    }
    
    func menuNavButton() -> UIButton?{
        let button = UIButton(image: UIImage(named: "menu")!)
        button?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        button?.addTarget(self, action: #selector(leftNavTap(_:)), for: .touchUpInside)
        
        return button
        
    }
    
    func searchCancelNavButton() -> UIButton? {
        let button = UIButton(image: UIImage(named: "searchCancelImage")!)
        button?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        button?.addTarget(self, action: #selector(cancelSearchTap(_:)), for: .touchUpInside)
        
        return button
    }
    
    func performSearch(_ timer: Timer?) {
        let info = timer?.userInfo as? [String: Any]
//        print(info)
        
        if info?["q"] as! String != ""{
            let baseURL = ConfigManger.shared["services"]["baseApiURL"].stringValue
            //        let q = "q=\(info["q"] as! String)"
            Alamofire.request(baseURL + "/search/users?q=\(info?["q"] as! String)", method: .get).responseJSON {[weak self] (response) in
                
                guard let strongSelf = self else { return }
                
                
                let data = response.result.value as! [[String : Any]]
                //            strongSelf.profileSampleView.profileNameLabel.text = "@\(data["username"] as! String)"
                print(data)
                
                strongSelf.data = data
                strongSelf.tableView.reloadData()
            }
        } else {
            data?.removeAll()
            tableView.reloadData()

        }
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "from_Search_to_Profile" &&
            segue.destination is ProfileViewController {
            
            let pVC = segue.destination as! ProfileViewController
            pVC.profileId = sender as? String
            
        }
    }



}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: searchCancelNavButton()!), animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        if let searchTimer = self.searchTimer {
            searchTimer.invalidate()
        }
        
        searchTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(performSearch(_:)), userInfo: ["q": updatedString], repeats: false)
        
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignSearch()
        return true
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.data {
            return data.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileSampleCell
        
        let cellData = data?[indexPath.row]
        
        cell.profileNameLabel?.text =  "@\(cellData?["username"] as! String)"
        cell.profileImageView.image = UIImage(named: ConfigManger.shared["Left_Nav_Screen"]["header"]["profileImage"]["placeholder"].stringValue)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resignSearch()
        
        performSegue(withIdentifier: "from_Search_to_Profile", sender: data?[indexPath.row]["id"])
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

