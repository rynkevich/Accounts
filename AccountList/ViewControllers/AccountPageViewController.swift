import UIKit

class AccountPageViewController: UIViewController {
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailOutputLabel: UILabel!
    @IBOutlet weak var usernameOutputLabel: UILabel!
    @IBOutlet weak var firstNameOutputLabel: UILabel!
    @IBOutlet weak var lastNameOutputLabel: UILabel!
    @IBOutlet weak var genderOutputLabel: UILabel!
    @IBOutlet weak var dateOfBirthOutputLabel: UILabel!
    @IBOutlet weak var countryOutputLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    private let notSpecifiedPlaceholder = "<None>"
    private var dateFormatter: DateFormatter!
    
    var currentAccount: AccountManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        initializeAvatarImageView()
        
        setFields(toAccountData: currentAccount)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let deleteAlert = UIAlertController(
            title: "Delete account",
            message: "Account will be removed permanently.",
            preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        deleteAlert.addAction(
            UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                self.currentAccount.managedObjectContext!.delete(self.currentAccount)
                self.navigationController!.popViewController(animated: true)
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    private func initializeAvatarImageView() {
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
    }
    
    private func setFields(toAccountData account: AccountManagedObject) {
        emailOutputLabel.text = account.email
        usernameOutputLabel.text = account.username
        firstNameOutputLabel.text = account.firstName
        lastNameOutputLabel.text = account.lastName
        genderOutputLabel.text = account.gender
        dateOfBirthOutputLabel.text = dateFormatter!.string(from: account.dateOfBirth!)
        countryOutputLabel.text = account.country
        bioTextView.text = account.biography ?? notSpecifiedPlaceholder
        if account.avatar != nil {
            avatarImageView.image = UIImage(data: account.avatar!, scale: 1.0)
        }
    }
    
}
