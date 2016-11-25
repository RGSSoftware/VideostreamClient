//
//  SerchViewController.swift
//  
//
//  Created by PC on 11/25/16.
//
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftArrowButton = UIButton(image: UIImage(named: "menu")!)
        leftArrowButton?.setFrameSizeHeight((navigationController?.navigationBar.frame.size.height)!)
        leftArrowButton?.addTarget(self, action: #selector(leftNavTap(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftArrowButton!)
    }
    
    func leftNavTap(_ id: Any) {
        navigationController?.sideMenuViewController.presentLeftMenuViewController()
    }

}

extension SearchViewController: UITextFieldDelegate {
    
}
