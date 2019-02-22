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

    convenience init(r: Int, g: Int, b: Int, a: Int) {
        self.init(red:   CGFloat(CGFloat(r) / 255.0),
                  green: CGFloat(CGFloat(g) / 255.0),
                  blue:  CGFloat(CGFloat(b) / 255.0),
                  alpha: CGFloat(CGFloat(a) / 255.0))
    }
}
