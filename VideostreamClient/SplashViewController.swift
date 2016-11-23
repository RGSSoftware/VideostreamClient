//
//  SplashViewController.swift
//  VideostreamClient
//
//  Created by PC on 11/19/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit
import RESideMenu

class SplashViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isUserAuthenticatedUrl(url: URL(string: ConfigManger.shared["services"]["baseApiURL"].stringValue)!){
            
            let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home_Screen")
            let leftNavVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Left_Nav_Screen")
            let sideMenuVC = RESideMenu(contentViewController: homeVC, leftMenuViewController: leftNavVC, rightMenuViewController: nil)
            sideMenuVC?.panGestureEnabled = false
            sideMenuVC?.menuPrefersStatusBarHidden = true
            sideMenuVC?.contentViewScaleValue = 0.9
    
            present(sideMenuVC!, animated: true, completion: nil)
            
            
        } else {
            performSegue(withIdentifier: "from_Splash_to_Login", sender: self)
        }
    }
    

    func isUserAuthenticatedUrl(url: URL) -> Bool {
        
        for cookie in HTTPCookieStorage.shared.cookies! {
            
            if let host = url.host, let expiresDate = cookie.expiresDate {
                
                if host == cookie.domain &&
                    expiresDate > Date(){
                    return true
                    
                }
            }
        }
        
        return false
    }

}
