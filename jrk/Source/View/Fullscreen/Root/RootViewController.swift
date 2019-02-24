//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let connections = ServerConnection.loadAll()
        print("Connections: \(connections)")

        add(SetupViewController())
    }
}

