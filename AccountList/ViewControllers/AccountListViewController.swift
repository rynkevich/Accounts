import UIKit

class AccountListViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setGradientBackground(
            gradientColors: [UIColor(red: 35/255, green: 160/255, blue: 175/255, alpha: 1.0).cgColor,
                             UIColor(red: 100/255, green: 170/255, blue: 90/255, alpha: 1.0).cgColor])
    }
    
}