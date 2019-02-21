//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
//  Later shamelessly axed to pieces by me.
//

import UIKit

@objc public extension UIFont {
    @objc public static var title1: UIFont {
        return UIFont.boldSystemFont(ofSize: 34.0)
    }

    @objc public static var title2: UIFont {
        return UIFont.boldSystemFont(ofSize: 28.0)
    }

    @objc public static var title3: UIFont {
        return UIFont.boldSystemFont(ofSize: 22)
    }

    @objc public static var title4: UIFont {
        return UIFont.systemFont(ofSize: 22)
    }

    @objc public static var body: UIFont {
        return UIFont.systemFont(ofSize: 16)
    }

    @objc public static var caption: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }

    @objc public static var title5: UIFont {
        return UIFont.systemFont(ofSize: 12)
    }
}
