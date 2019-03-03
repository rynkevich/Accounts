import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    let borderColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0)
    let genderList = ["Male", "Female"]
    
    let dateFormatter: DateFormatter
    var dateOfBirthPicker: UIDatePicker?
    var genderPickerView: UIPickerView?
    
    required init?(coder aDecoder: NSCoder) {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.image = UIImage(named: "no-image-available")
        avatarImageView.layer.borderColor = borderColor.cgColor
        avatarImageView.layer.borderWidth = 0.5
        avatarImageView.layer.cornerRadius = 5
        
        bioTextView.layer.borderColor = borderColor.cgColor
        bioTextView.layer.borderWidth = 0.5
        bioTextView.layer.cornerRadius = 5
        
        dateOfBirthPicker = UIDatePicker()
        dateOfBirthPicker?.datePickerMode = .date
        dateOfBirthPicker?.maximumDate = Date()
        dateOfBirthPicker?.addTarget(self, action: #selector(self.dateOfBirthChanged), for: .valueChanged)
        dateOfBirthField.inputView = dateOfBirthPicker
        
        genderPickerView = UIPickerView()
        genderPickerView?.dataSource = self
        genderPickerView?.delegate = self
        genderField.inputView = genderPickerView
        
        let viewTappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        view.addGestureRecognizer(viewTappedGestureRecognizer);
    }
    
    @objc func dateOfBirthChanged(datePicker: UIDatePicker) {
        dateOfBirthField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension CreateAccountViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genderList[row]
        view.endEditing(true)
    }
    
}

