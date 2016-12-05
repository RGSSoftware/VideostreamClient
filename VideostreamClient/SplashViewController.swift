import Moya
import RESideMenu
import UIKit

class SplashViewController: UIViewController {

    var provider: RxMoyaProvider<StreamAPI>!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isUserAuthenticatedFor(URL(string: StreamAPI.base)!){
            
            let nVC = R.storyboard.main.navPager_Screen()!
            nVC.screenId = R.storyboard.main.navPager_Screen.identifier

            guard let wpVC = nVC.topViewController as? WatchPagerViewController else { return }
            wpVC.provider = provider
            
            let leftNavVC = R.storyboard.main.left_Nav_Screen()
            let sideMenuVC = RESideMenu(contentViewController: nVC, leftMenuViewController: leftNavVC, rightMenuViewController: nil)
            sideMenuVC?.panGestureEnabled = false
            sideMenuVC?.menuPrefersStatusBarHidden = true
            sideMenuVC?.contentViewScaleValue = 0.9
    
            present(sideMenuVC!, animated: true, completion: nil)
            
            
        } else {
            
            performSegue(withIdentifier: R.segue.splashViewController.from_Splash_to_Login, sender: self)
        }
    }
    

    func isUserAuthenticatedFor(_ url: URL) -> Bool {
        
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
