import UIKit
import CoreData

class SignInViewController : UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private var accountManager: AccountManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountManager = AccountManager((UIApplication.shared.delegate as! AppDelegate).persistentContainer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "currentUser") != nil {
            performSegue(withIdentifier: "showAccountsSegue", sender: self)
            return
        }
        
        super.viewWillAppear(animated)
        
        emailField.text = ""
        passwordField.text = ""
        
        navigationController!.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController!.setNavigationBarHidden(false, animated: false)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "showAccountsSegue":
            if emailField.text!.isEmpty {
                present(ErrorAlertFactory.getAlert(title: "Validation error", message: "Email is not specified"),
                       animated: true)
                return false
            }
            if passwordField.text!.isEmpty {
                present(ErrorAlertFactory.getAlert(title: "Validation error", message: "Password is not specified"),
                        animated: true)
                return false
            }
            
            let areValidCredentials = try! accountManager!.areValidCredentials(
                email: emailField.text!,
                passwordHash: passwordField.text!)
            
            if areValidCredentials {
                UserDefaults.standard.set(emailField.text!, forKey: "currentUser")
                return true
            } else {
                 present(ErrorAlertFactory.getAlert(title: "Authentication error",
                                                    message: "Incorrect email or password specified"),
                         animated: true)
                return false
            }
        default:
            return true
        }
    }
    
}
