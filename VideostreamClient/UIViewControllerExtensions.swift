import UIKit

extension UIViewController {

    /// Short hand syntax for loading the view controller 

    func loadViewProgrammatically(){
        self.beginAppearanceTransition(true, animated: false)
        self.endAppearanceTransition()
    }

}
