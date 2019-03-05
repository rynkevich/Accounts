import UIKit

class AccountListViewController: UIViewController {
    
    @IBOutlet weak var accountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAvatarImageView()
    }
    
    func initAvatarImageView() {
        accountButton.layer.borderColor = UIColor.clear.cgColor
        accountButton.layer.cornerRadius = accountButton.frame.size.width / 2
        accountButton.layer.masksToBounds = true
    }
    
}
