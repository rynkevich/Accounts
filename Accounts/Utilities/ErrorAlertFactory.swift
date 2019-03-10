import UIKit

class ErrorAlertFactory {
    
    public static func getAlert(title: String, message: String) -> UIAlertController {
        let errorAlert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        return errorAlert
    }
    
}
