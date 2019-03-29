//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let playerVc = createPlayerViewControllerIfPossible() {
            add(playerVc)
        } else {
            let setupController = SetupViewController()
            setupController.delegate = self
            add(setupController)
        }
    }

    private func createPlayerViewControllerIfPossible() -> PlayerViewController? {
        let appDelegate = UIApplication.shared.appDelegate
        if let player = appDelegate?.streamPlayer, let connection = appDelegate?.serverConnection {
            return PlayerViewController(connection: connection, player: player)
        }

        return nil
    }
}

extension RootViewController: SetupViewControllerDelegate {
    func setupViewController(_ setupVc: SetupViewController, didConfigureConnection connection: ServerConnection) {
        UIApplication.shared.appDelegate?.serverConnectionWasConfigured()

        if let playerVc = createPlayerViewControllerIfPossible() {
            present(playerVc, animated: true, completion: { [weak self] in
                self?.remove(setupVc)
            })
        } else {
            print("ERROR: failed to create PlayerViewController, even though SetupViewController configured: \(connection)")
        }
    }
}
