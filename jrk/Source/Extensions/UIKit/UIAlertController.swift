//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

extension UIAlertController {
    public class func errorAlert(withMessage message: String) -> UIAlertController {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return controller
    }
}
