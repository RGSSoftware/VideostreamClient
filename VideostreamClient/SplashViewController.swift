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
            let leftNavVC = R.storyboard.main.left_Nav_Screen()
            let sideMenuVC = RESideMenu(contentViewController: homeVC, leftMenuViewController: leftNavVC, rightMenuViewController: nil)
            sideMenuVC?.panGestureEnabled = false
            sideMenuVC?.menuPrefersStatusBarHidden = true
            sideMenuVC?.contentViewScaleValue = 0.9
    
            present(sideMenuVC!, animated: true, completion: nil)
            
            
        } else {
            
            performSegue(withIdentifier: R.segue.splashViewController.from_Splash_to_Login, sender: self)
        }
    }
    

    func isUserAuthenticatedUrl(url: URL) -> Bool {
        
        for cookie in HTTPCookieStorage.shared.cookies(for: url)! {
            
            if let expiresDate = cookie.expiresDate {
                
                if expiresDate > Date(){
                    return true
                    
                }
            }
        }
        
        return false
    }

}
