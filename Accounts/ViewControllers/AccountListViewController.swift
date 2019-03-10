import UIKit
import CoreData

class AccountListViewController: UIViewController {
    
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var accountsTableView: UITableView!
    
    private var accountManager: AccountManager!
    private var currentAccount: AccountManagedObject!
    private var accountList: [AccountManagedObject]!
    private var selectedAccountIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.setNavigationBarHidden(false, animated: false)
        
        initializeAvatarImageView()
        
        accountManager = AccountManager((UIApplication.shared.delegate as! AppDelegate).persistentContainer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentAccount = try! accountManager.getLoggedInUserAccount()
        usernameLabel.text = currentAccount.username
        emailLabel.text = currentAccount.email
        if currentAccount.avatar != nil {
            avatarButton.setImage(UIImage(data: currentAccount.avatar!, scale: 1.0), for: .normal)
        }
        
        accountList = try! accountManager.getAccountList()
        accountsTableView.reloadData()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if parent == nil {
            UserDefaults.standard.removeObject(forKey: "currentUser")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editLoggedInUserAccountSegue":
            let destination = segue.destination as! CreateAccountViewController
            destination.currentAccount = currentAccount
            destination.isLoggedIn = true
        case "addAccountSegue":
            let destination = segue.destination as! CreateAccountViewController
            destination.isLoggedIn = true
        case "showAccountSegue":
            let destination = segue.destination as! AccountPageViewController
            destination.currentAccount = accountList[selectedAccountIndex!]
        default:
            break
        }
    }
    
    private func initializeAvatarImageView() {
        accountButton.layer.borderColor = UIColor.white.cgColor
        accountButton.layer.borderWidth = 1.5
        accountButton.layer.cornerRadius = accountButton.frame.width / 2
        accountButton.clipsToBounds = true
    }
    
}

extension AccountListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "accountsCell")
        cell.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedBackgroundView
        cell.textLabel!.textColor = UIColor.white
        cell.textLabel!.text = "• \(accountList[indexPath.row].username!)"
        cell.separatorInset = UIEdgeInsets.zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAccountIndex = indexPath.row
        
        performSegue(withIdentifier: "showAccountSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        let titleLabel = UILabel()
        titleLabel.text = "Accounts"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        titleLabel.frame = CGRect(x: 10, y: -5, width: 300, height: 35)
        view.addSubview(titleLabel)
        
        return view
    }
    
}
