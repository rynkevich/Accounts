import UIKit

class AccountPageViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAvatarImageView()
    }
    
    func initAvatarImageView() {
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.cornerRadius = 5
    }
    
}
