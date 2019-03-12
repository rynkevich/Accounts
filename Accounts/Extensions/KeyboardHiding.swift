import UIKit

extension UIViewController {
    
    func hideKeyboardOnTap() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
