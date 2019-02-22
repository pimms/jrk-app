//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

extension UIViewController {
    public func add(_ viewController: UIViewController) {
        guard viewController.parent == nil else {
            print("Attempted to add a non-orphan view controller")
            return
        }

        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

    public func remove(_ viewController: UIViewController) {
        guard viewController.parent == self else {
            print("Can only remove my own child-controllers")
            return
        }

        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
    }
}
