//
//  StreamsViewController.swift
//  VideostreamClient
//
//  Created by PC on 11/19/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit

import Alamofire
import XLPagerTabStrip


class StreamsViewController: UITableViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
    var dataStore: DataStore?

    
    var data: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.dataStore?.fetch(){ [weak self] (error, isSuccessful) in
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.reloadData()
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore!.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ACell", for: indexPath)
        
        let cellData = dataStore!.data[indexPath.row]
        
        cell.textLabel?.text =  cellData["username"] as? String
        
        return cell
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        print("itemInfo: \(itemInfo)")
        return itemInfo
    }
    
    
}

