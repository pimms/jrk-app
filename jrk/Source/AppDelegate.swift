//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var serverConnection: ServerConnection?
    var streamPlayer: StreamPlayer?

    override init() {
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadPlayer()
        return true
    }

    func serverConnectionWasConfigured() {
        loadPlayer()
    }

    private func loadPlayer() {
        if let connection = ServerConnection.loadFirst() {
            if let url = URL(string: connection.rootUrl)?.appendingPathComponent(connection.playlistPath) {
                serverConnection = connection
                streamPlayer = StreamPlayer(streamUrl: url)
            }
        }
    }
}

