//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

protocol Identifiable {
    static var reuseIdentifier: String { get }
}

extension Identifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
