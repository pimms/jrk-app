//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import Foundation

extension Data {
    func decoded<T: Decodable>(with decoder: JSONDecoder = .init()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }
}
