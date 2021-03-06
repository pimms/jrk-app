//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case failedToDecode
    case unknownError
}

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

class NetworkClient: NSObject {
    let rootUrl: URL

    private let decoder = JSONDecoder()

    required init?(rootUrl: String) {
        guard let url = URL(string: rootUrl) else {
            return nil
        }

        self.rootUrl = url
        super.init()
    }

    func performRaw(path: String, dataCallback: @escaping (Data?, Error?) -> Void) {
        let url = rootUrl.appendingPathComponent(path)
        let urlString = url.absoluteString
        print("Performing request to: \(urlString)")

        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            if error != nil {
                print("Request failed: \(urlString) (\(error!))")
            } else {
                print("Request completed: \(urlString)")
            }

            DispatchQueue.main.async {
                dataCallback(data, error)
            }
        })

        task.resume()
    }

    func performRawSync(path: String) -> (Data?, Error?) {
        var data: Data?
        var error: Error?
        let semaphore = DispatchSemaphore(value: 0)

        performRaw(path: path, dataCallback: {
            data = $0
            error = $1
            semaphore.signal()
        })

        _ = semaphore.wait(timeout: .now() + 20.0)

        return (data, error)
    }

    func perform<T: Decodable>(path: String, dataCallback: @escaping (Result<T>) -> Void) {
        performRaw(path: path, dataCallback: { [weak self] data, error in
            guard let self = self else {
                dataCallback(Result.failure(NetworkError.unknownError))
                return
            }

            do {
                if let decoded: T = try data?.decoded(with: self.decoder) {
                    dataCallback(Result.success(decoded))
                } else {
                    let err = error ?? NetworkError.failedToDecode
                    dataCallback(Result.failure(err))
                }
            } catch {
                dataCallback(Result.failure(error))
            }
        })
    }
}
