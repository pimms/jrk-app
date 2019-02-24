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

        let fileManager = FileManager.default
        guard let docDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to resolve the Documents Directory path")
            return nil
        }

        return docDir.appendingPathComponent(directoryName, isDirectory: true)
    }

    private func createDirectoryIfNotExist(directoryUrl: URL) -> Bool {
        let manager = FileManager.default

        var isDir: ObjCBool = false
        let exists = manager.fileExists(atPath: directoryUrl.relativePath, isDirectory: &isDir)

        if exists, isDir.boolValue {
            print("Directory  already exists: \(directoryUrl.relativePath)")
            return true
        } else if exists, !isDir.boolValue {
            print("A non-directory file exists at \(directoryUrl.relativePath)")
            return false
        }

        do {
            try manager.createDirectory(atPath: directoryUrl.relativePath, withIntermediateDirectories: true, attributes: nil)
            print("Created directory '\(directoryUrl.relativePath)'")
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
