//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init(named name: ImageAsset) {
        self.init(named: name.rawValue)!
    }
}

enum ImageAsset: String {
    case jrkLight
}
