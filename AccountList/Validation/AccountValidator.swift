import Foundation

class AccountValidator {
    
    static func validateAccountFields(in vc: CreateAccountViewController, isEditing: Bool) -> String? {
        if vc.emailField.text!.isEmpty { return "Email is not specified" }
        if !isEditing && vc.passwordField.text!.isEmpty { return "Password is not specified" }
        if vc.usernameField.text!.isEmpty { return "Username is not specified" }
        if vc.firstNameField.text!.isEmpty { return "First name is not specified" }
        if vc.lastNameField.text!.isEmpty { return "Last name is not specified" }
        if vc.genderField.text!.isEmpty { return "Gender is not specified" }
        if vc.dateOfBirthField.text!.isEmpty { return "Date of birth is not specified" }
        if vc.countryField.text!.isEmpty { return "Country is not specified" }
        
        if !isEmail(vc.emailField.text!) { return "Email is not valid" }
        if !isEditing && vc.passwordField.text! != vc.repeatPasswordField.text! {
            return "Password and repeated password must be identical"
        }
        if !isUsername(vc.usernameField.text!) { return "Username must contain only digits, letters and symbols -_" }
        if !isName(vc.firstNameField.text!) { return "First name is not a valid name" }
        if !isName(vc.lastNameField.text!) { return "Last name is not a valid name" }
        
        return nil
    }
    
    private static func isEmail(_ email: String) -> Bool {
        let emailPattern = "^[0-9a-z.\\_%+-]+@[a-z0-9.-]+\\.[a-z]{2,64}$"
        let emailRegex = try! NSRegularExpression(pattern: emailPattern, options: .caseInsensitive)
        
        return emailRegex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
    private static func isUsername(_ username: String) -> Bool {
        let usernamePattern = "^[0-9a-z\\-\\_]+$"
        let usernameRegex = try! NSRegularExpression(pattern: usernamePattern, options: .caseInsensitive)
        
        return usernameRegex.firstMatch(
            in: username, options: [], range: NSRange(location: 0, length: username.count)) != nil
    }
    
    private static func isName(_ name: String) -> Bool {
        let namePattern = "^[a-z]+([ \\-][a-z]+)*$"
        let nameRegex = try! NSRegularExpression(pattern: namePattern, options: .caseInsensitive)
        
        return nameRegex.firstMatch(
            in: name, options: [], range: NSRange(location: 0, length: name.count)) != nil
    }
    
}
