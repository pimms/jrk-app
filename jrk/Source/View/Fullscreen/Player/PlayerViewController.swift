//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    // MARK: - Private properties

    private let serverConnection: ServerConnection

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }

    init(server: ServerConnection) {
        self.serverConnection = server
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        view.backgroundColor = .defaultBackground
    }
}
