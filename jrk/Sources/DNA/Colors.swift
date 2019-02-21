//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red:   CGFloat(CGFloat(r) / 255.0),
                  green: CGFloat(CGFloat(g) / 255.0),
                  blue:  CGFloat(CGFloat(b) / 255.0),
                  alpha: 1.0)
    }
}

extension UIColor {
    public class var defaultBackground: UIColor {
        return UIColor(r: 34, g: 34, b: 34)
    }

    // MARK: - Action button

    public class var actionButtonBackground: UIColor {
        return UIColor(r: 34, g: 120, b: 200)
    }

    public class var actionButtonBackgroundHighlight: UIColor {
        return UIColor(r: 34/2, g: 120/2, b: 200/2)
    }

    public class var actionButtonBackgroundDisabled: UIColor {
        return UIColor(r: 15, g: 50, b: 80)
    }


    // MARK: - Destructive button

    public class var destructiveButtonBackground: UIColor {
        return UIColor(r: 230, g: 50, b: 50)
    }

    public class var destructiveButtonBackgroundHighlight: UIColor {
        return UIColor(r: 230/2, g: 50/2, b: 50/2)
    }

    public class var destructiveButtonBackgroundDisabled: UIColor {
        return UIColor(r: 90, g: 10, b: 20)
    }


    public class var defaultText: UIColor {
        return UIColor(r: 200, g: 200, b: 200)
    }
}
