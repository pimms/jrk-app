//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import Foundation

struct NowPlaying: Decodable, Equatable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case episodeKey = "key"
        case episodeName = "name"
        case season
    }

    let episodeKey: String
    let episodeName: String
    let season: String
}

protocol NowPlayingClient: class {
    func fetchNowPlaying(dataCallback: @escaping (Result<NowPlaying>) -> Void)
}

extension NetworkClient: NowPlayingClient {
    func fetchNowPlaying(dataCallback: @escaping (Result<NowPlaying>) -> Void) {
        perform(path: "/live/nowPlaying", dataCallback: dataCallback)
    }
}
