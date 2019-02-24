//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let connection = ServerConnection.loadFirst() {
            let playerController = PlayerViewController(server: connection)
            add(playerController)
        } else {
            let setupController = SetupViewController()
            setupController.delegate = self
            add(setupController)
        }
    }
}

extension RootViewController: SetupViewControllerDelegate {
    func setupViewController(_: SetupViewController, didConfigureConnection connection: ServerConnection) {
        let playerController = PlayerViewController(server: connection)
        present(playerController, animated: true)
    }
}
