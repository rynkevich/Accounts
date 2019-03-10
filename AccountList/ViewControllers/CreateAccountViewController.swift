import UIKit
import CoreData

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var personalDataSwitch: UISwitch!
    @IBOutlet weak var personalDataLabel: UILabel!
    
    private let genderList = ["Male", "Female"]
    private var accountManager: AccountManager!
    private var countryList: [String]!
    private var dateFormatter: DateFormatter!
    private var dateOfBirthPicker: UIDatePicker!
    private var genderPickerView: UIPickerView!
    private var countryPickerView: UIPickerView!
    private var pickedGenderIndex: Int?
    private var pickedCountryIndex: Int?
    
    var currentAccount: AccountManagedObject?
    var isLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.setNavigationBarHidden(false, animated: false)
        
        dateFormatter = DateFormatter()
        dateFormatter!.dateFormat = "MM/dd/yyyy"
        accountManager = AccountManager((UIApplication.shared.delegate as! AppDelegate).persistentContainer)
        
        initializeAvatarButton()
        initializeBioTextView()
        initializeDateOfBirthPicker()
        initializeGenderPickerView()
        initializeCountryPickerView()
        
        if isLoggedIn {
            emailField.isEnabled = false
            personalDataSwitch.isHidden = true
            personalDataLabel.isHidden = true
            doneButton.isEnabled = true
            
            if currentAccount != nil {
                setFields(toAccountData: currentAccount!)
            }
        }
    }
    
    @IBAction func avatarButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true)
    }
    
    @IBAction func personalDataSwitchValueChanged(_ sender: UISwitch) {
        doneButton.isEnabled = sender.isOn
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        let validationResult = AccountValidator.validateAccountFields(in: self, isEditing: currentAccount != nil)
        if validationResult != nil {
            present(ErrorAlertFactory.getAlert(title: "Error", message: validationResult!), animated: true)
            return
        }
        
        if currentAccount == nil || emailField.text! != currentAccount!.email {
            if try! !accountManager.isUniqueEmail(emailField.text!) {
                present(ErrorAlertFactory.getAlert(
                    title: "Error", message: "User with specified email already exists"), animated: true)
                return
            }
        }
        if currentAccount == nil || usernameField.text! != currentAccount!.username {
            if try! !accountManager.isUniqueUsername(usernameField.text!) {
                present(ErrorAlertFactory.getAlert(
                    title: "Error", message: "User with specified name already exists"), animated: true)
                return
            }
        }
        
        if currentAccount != nil {
            saveInputAccountData(to: currentAccount!)
            
            try! currentAccount!.managedObjectContext!.save()
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let dataContext = appDelegate.persistentContainer.viewContext
            
            let newAccount = AccountManagedObject(context: dataContext)
            saveInputAccountData(to: newAccount)
            
            try! dataContext.save()
        
            if !isLoggedIn {
                UserDefaults.standard.set(newAccount.email, forKey: "currentUser")
            }
        }
        
        navigationController!.popViewController(animated: true)
    }
    
    private func initializeAvatarButton() {
        avatarButton.layer.borderColor = UIColor.white.cgColor
        avatarButton.layer.borderWidth = 1
        avatarButton.layer.cornerRadius = avatarButton.frame.width / 2
        avatarButton.clipsToBounds = true
    }
    
    private func initializeBioTextView() {
        bioTextView.layer.borderColor = UIColor(
            red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        bioTextView.layer.borderWidth = 0.5
        bioTextView.layer.cornerRadius = 5
    }
    
    private func initializeDateOfBirthPicker() {
        dateOfBirthPicker = UIDatePicker()
        dateOfBirthPicker.datePickerMode = .date
        dateOfBirthPicker.maximumDate = Date()
        
        dateOfBirthField.inputAccessoryView = createToolbar(onDoneAction: #selector(dateOfBirthPicked))
        dateOfBirthField.inputView = dateOfBirthPicker
    }
    
    private func initializeGenderPickerView() {
        genderPickerView = UIPickerView()
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        
        genderField.inputAccessoryView = createToolbar(onDoneAction: #selector(genderPicked))
        genderField.inputView = genderPickerView
    }
    
    private func initializeCountryPickerView() {
        countryList = NSLocale.isoCountryCodes
        countryList = countryList.map({
            NSLocale(localeIdentifier: "en_US").displayName(forKey: .countryCode, value: $0)!
        })
        countryList.sort()
        
        countryPickerView = UIPickerView()
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        
        countryField.inputAccessoryView = createToolbar(onDoneAction: #selector(countryPicked))
        countryField.inputView = countryPickerView
    }
    
    @objc private func dateOfBirthPicked() {
        dateOfBirthField.text = dateFormatter.string(from: dateOfBirthPicker.date)
        view.endEditing(true)
    }
    
    @objc private func genderPicked() {
        genderField.text = pickedGenderIndex != nil ? genderList[pickedGenderIndex!] : genderList[0]
        view.endEditing(true)
    }
    
    @objc private func countryPicked() {
        countryField.text = pickedCountryIndex != nil ? countryList[pickedCountryIndex!] : countryList[0]
        view.endEditing(true)
    }
    
    @objc private func viewEndEditing() {
        view.endEditing(true)
    }
    
    private func createToolbar(onDoneAction action: Selector?) -> UIToolbar {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: action)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(viewEndEditing))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        
        return toolbar
    }
    
    private func saveInputAccountData(to account: AccountManagedObject) {
        account.email = emailField.text
        if !passwordField.text!.isEmpty {
            account.passwordHash = passwordField.text
        }
        account.username = usernameField.text
        account.firstName = firstNameField.text
        account.lastName = lastNameField.text
        account.gender = genderField.text
        account.dateOfBirth = dateOfBirthPicker.date
        account.country = countryField.text
        account.biography = bioTextView.text!.isEmpty ? nil : bioTextView.text
        account.avatar = avatarButton.image(for: .normal)!.pngData()
    }
    
    private func setFields(toAccountData account: AccountManagedObject) {
        emailField.text = account.email
        usernameField.text = account.username
        firstNameField.text = account.firstName
        lastNameField.text = account.lastName
        genderField.text = account.gender
        dateOfBirthField.text = dateFormatter.string(from: account.dateOfBirth!)
        countryField.text = account.country
        bioTextView.text = account.biography ?? ""
        if account.avatar != nil {
            avatarButton.setImage(UIImage(data: account.avatar!, scale: 1.0), for: .normal)
        }
    }
    
}

extension CreateAccountViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength: Int
        
        switch textField {
        case emailField:
            maxLength = 40
        case usernameField:
            maxLength = 20
        case firstNameField:
            fallthrough
        case lastNameField:
            maxLength = 40
        default:
            maxLength = 100
        }
        
        return (textField.text! as NSString).replacingCharacters(in: range, with: string).count <= maxLength
    }
    
}

extension CreateAccountViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case genderPickerView:
            return genderList.count
        case countryPickerView:
            return countryList.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case genderPickerView:
            return genderList[row]
        case countryPickerView:
            return countryList[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case genderPickerView:
            pickedGenderIndex = row
        case countryPickerView:
            pickedCountryIndex = row
        default:
            break
        }
    }
    
}

extension CreateAccountViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        avatarButton.setImage(image, for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
