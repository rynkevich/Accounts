import UIKit

class GradientBackgroundView: UIView {
    
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [
            UIColor(red: 35/255, green: 160/255, blue: 175/255, alpha: 1.0).cgColor,
            UIColor(red: 100/255, green: 170/255, blue: 90/255, alpha: 1.0).cgColor
        ]
    }
}
