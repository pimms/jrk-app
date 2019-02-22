//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import Foundation

struct ServerInfo: Decodable, Equatable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case playlistUrl = "playlistURL"
        case streamName
        case streamPictureUrl = "streamPictureURL"
    }

    let playlistUrl: String
    let streamName: String
    let streamPictureUrl: String
}

protocol ServerInfoClient: class {
    func fetchServerInfo(dataCallback: @escaping (Result<ServerInfo>) -> Void)
}

extension NetworkClient: ServerInfoClient {
    public func fetchServerInfo(dataCallback: @escaping (Result<ServerInfo>) -> Void) {
        perform(path: "/", dataCallback: dataCallback)
    }
}
