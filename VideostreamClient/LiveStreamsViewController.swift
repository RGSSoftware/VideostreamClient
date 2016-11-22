//
//  StreamsViewController.swift
//  VideostreamClient
//
//  Created by PC on 11/19/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit

class LiveStreamsViewController: UIViewController {
    
    var data : [[[String : Any]]] = [[[:]]]

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for section in 0...1 {
            for row in 0...19 {
                let streamer = [
                    "name" : randomString(length: 5)
                ]
                data[section][row] = streamer
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func randomString(length:Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = charSet.characters.map { String($0) }
        var s:String = ""
        for _ in (1...length) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
    
}



extension LiveStreamsViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StreamerCell", for: indexPath) as! StreamerCell
        
        let cellData = data[indexPath.section][indexPath.row]
        
        cell.nameLabel.text =  cellData["name"] as? String
        
        return cell
    }
}

extension LiveStreamsViewController : UICollectionViewDelegate {
    
}
