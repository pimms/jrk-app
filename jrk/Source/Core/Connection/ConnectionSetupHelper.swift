//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

enum ConnectionSetupError: Error {
    case deallocated
    case generalFailure
    case failedToFetchImage
}

class ConnectionSetupHelper {
    private let dispatchQueue = DispatchQueue(label: "ConnectionSetupHelper")
    private var networkClient: NetworkClient?

    func attempt(withRootUrl rootUrl: String, resultHandler: @escaping (Result<ServerConnection>) -> Void) {
        guard let client = NetworkClient(rootUrl: rootUrl) else {
            resultHandler(Result.failure(ConnectionSetupError.generalFailure))
            return
        }

        networkClient = client
        client.perform(path: "/", dataCallback: { [weak self] (result: Result<ServerInfo>) in
            guard let self = self else {
                resultHandler(Result.failure(ConnectionSetupError.deallocated))
                return
            }

            switch (result) {
            case .success(let serverInfo):
                self.dispatchQueue.async {
                    guard let image = self.downloadImageSync(path: serverInfo.streamPicturePath) else {
                        DispatchQueue.main.async {
                            resultHandler(Result.failure(ConnectionSetupError.failedToFetchImage))
                        }
                        return
                    }

                    let connection = ServerConnection(rootUrl: rootUrl,
                                                      coverImagePath: serverInfo.streamPicturePath,
                                                      playlistPath: serverInfo.playlistPath,
                                                      coverImage: image)
                    DispatchQueue.main.async {
                        resultHandler(Result.success(connection))
                    }
                }

            case .failure(let err):
                DispatchQueue.main.async {
                    resultHandler(Result.failure(err))
                }
            }
        })
    }

    private func downloadImageSync(path: String) -> UIImage? {
        guard let client = networkClient else { return nil }

        let (data, error) = client.performRawSync(path: path)

        guard error == nil else {
            print("Failed to fetch image: \(error!)")
            return nil
        }

        guard let imageData = data, let image = UIImage(data: imageData) else {
            print("Failed to convert data to UIImage")
            return nil
        }

        return image
    }
}
