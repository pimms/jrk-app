//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import Foundation

struct ServerInfo: Decodable, Equatable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case streamName
        case playlistPath = "playlist"
        case streamPicturePath = "streamPicture"
    }

    let streamName: String
    let playlistPath: String
    let streamPicturePath: String
}

protocol ServerInfoClient: class {
    func fetchServerInfo(dataCallback: @escaping (Result<ServerInfo>) -> Void)
}

extension NetworkClient: ServerInfoClient {
    public func fetchServerInfo(dataCallback: @escaping (Result<ServerInfo>) -> Void) {
        perform(path: "/", dataCallback: dataCallback)
    }
}
