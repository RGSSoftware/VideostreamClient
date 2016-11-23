//
//  StreamsViewController.swift
//  VideostreamClient
//
//  Created by PC on 11/19/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class StreamsViewController: UITableViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"

    
    var data : [[[String : Any]]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for sectionIndex in 0...1 {
            var section : [[String : Any]] = []
            for rowIndex in 0...19 {
                let streamer = [
                    "name" : "abcdef"
                ]
                section.insert(streamer, at: rowIndex)
            }
            data.insert(section, at: sectionIndex)
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ACell", for: indexPath)
        
        let cellData = data[indexPath.section][indexPath.row]
        
        cell.textLabel?.text =  cellData["name"] as? String
        
        return cell
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        print("itemInfo: \(itemInfo)")
        return itemInfo
    }
    
    
}

