//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

struct ServerConnection {
    let rootUrl: String
    let coverImagePath: String
    let playlistPath: String
    let coverImage: UIImage
}

// MARK: Saving

extension ServerConnection {
    private static func containerDirectory() -> URL? {
        let fileManager = FileManager.default
        guard let docDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to resolve the Documents Directory path")
            return nil
        }

        return docDir.appendingPathComponent("servers", isDirectory: true)
    }
}

extension ServerConnection {
    public func save() -> Bool {
        guard let rootDirectory = rootDirectory() else {
            print("Failed to generate root-directory name")
            return false
        }

        guard createDirectoryIfNotExist(directoryUrl: rootDirectory) else {
            print("Failed to create directory")
            return false
        }

        guard save(inDirectory: rootDirectory) else {
            print("Failed to save in directory")
            return false
        }

        print("Successfully saved ServerConnection to \(rootDirectory.relativePath)")

        return true
    }

    private func rootDirectory() -> URL? {
        guard let directoryName = rootUrl.md5 else {
            print("Unable to hash the root URL")
            return nil
        }

        return ServerConnection.containerDirectory()?.appendingPathComponent(directoryName, isDirectory: true)
    }

    private func createDirectoryIfNotExist(directoryUrl: URL) -> Bool {
        let manager = FileManager.default

        var isDir: ObjCBool = false
        let exists = manager.fileExists(atPath: directoryUrl.relativePath, isDirectory: &isDir)

        if exists, isDir.boolValue {
            return true
        } else if exists, !isDir.boolValue {
            print("A non-directory file exists at \(directoryUrl.relativePath)")
            return false
        }

        do {
            try manager.createDirectory(atPath: directoryUrl.relativePath, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch let error as NSError {
            print("Failed to create directory '\(directoryUrl.relativePath)': \(error.localizedDescription)");
            return false
        }
    }

    private func save(inDirectory path: URL) -> Bool {
        guard saveServerInformation(inDirectory: path),
              saveCoverImage(inDirectory: path) else {
            return false
        }

        return true
    }

    private func saveServerInformation(inDirectory path: URL) -> Bool {
        var dict = [String:String]()
        dict["rootUrl"] = rootUrl
        dict["coverImagePath"] = coverImagePath
        dict["playlistPath"] = playlistPath
        let plistUrl = path.appendingPathComponent("serverinfo.plist")

        do {
            try NSDictionary(dictionary: dict).write(to: plistUrl)
            print("Saved server information")
            return true
        } catch {
            print("Failed to save file \(plistUrl.relativePath): \(error)")
            return false
        }
    }

    private func saveCoverImage(inDirectory path: URL) -> Bool {
        let coverImageUrl = path.appendingPathComponent("coverImage.png")

        guard let pngData = coverImage.pngData() else {
            print("Failed to retrieve PNG-data from cover image")
            return false
        }

        do {
            try pngData.write(to: coverImageUrl)
            print("Saved coverImage")
            return true
        } catch {
            print("Failed to save cover image \(coverImageUrl.relativePath): \(error)")
            return false
        }
    }
}

// MARK: - Loading

extension ServerConnection {
    public static func loadAll() -> [ServerConnection]? {
        return load(n: Int.max)
    }

    public static func loadFirst() -> ServerConnection? {
        return load(n: 1)?.first
    }

    private static func load(n: Int) -> [ServerConnection]? {
        guard let containerDirectory = containerDirectory() else {
            return nil
        }

        let entries: [String]
        do {
            entries = try FileManager.default.contentsOfDirectory(atPath: containerDirectory.relativePath)
        } catch {
            print("Failed to list contents of container directory: \(error)")
            return nil
        }

        var connections = [ServerConnection]()

        for entry in entries {
            let directory = containerDirectory.appendingPathComponent(entry, isDirectory: true)
            if let connection = load(fromDirectory: directory) {
                connections.append(connection)
                if connections.count >= n {
                    break
                }
            }
        }

        return connections
    }


    private static func load(fromDirectory directory: URL) -> ServerConnection? {
        let imagePath = directory.appendingPathComponent("coverImage.png")
        guard let coverImage = UIImage(contentsOfFile: imagePath.relativePath) else {
            print("Failed to load image")
            return nil
        }

        let plistPath = directory.appendingPathComponent("serverinfo.plist")
        guard let dict = NSDictionary(contentsOfFile: plistPath.relativePath) else {
            print("Failed to load dictionary")
            return nil
        }

        guard let rootUrl = dict["rootUrl"] as? String,
              let coverImagePath = dict["coverImagePath"] as? String,
              let playlistPath = dict["playlistPath"] as? String else {
            print("Failed to find expected elements in dict")
            return nil
        }

        return ServerConnection(rootUrl: rootUrl,
                                coverImagePath: coverImagePath,
                                playlistPath: playlistPath,
                                coverImage: coverImage)
    }
}
