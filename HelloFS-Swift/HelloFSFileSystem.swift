//
//  HelloFSFileSystem.swift
//  HelloFS-Swift
//
//  Created by Gunnar Herzog on 28/09/2016.
//
//

import Foundation

private let helloStr = "Hello World!\n"
private let helloPath = "/hello.txt"

private let hasCustomIcon: Int64 = 0x0400

class HelloFSFileSystem: NSObject {

    override func contentsOfDirectory(atPath path: String!) throws -> [Any] {
        return [(helloPath as NSString).lastPathComponent]
    }

    override func contents(atPath path: String!) -> Data! {
        guard path == helloPath else { return nil }

        return helloStr.data(using: .utf8)
    }

    // MARK: - optional Custom Icon

    override func finderAttributes(atPath path: String!) throws -> [AnyHashable : Any] {
        guard path == helloPath else { throw NSError(domain: NSCocoaErrorDomain, code: Int(ENOATTR)) }

        let finderFlags = NSNumber(value: hasCustomIcon)
        return [kGMUserFileSystemFinderFlagsKey: finderFlags]
    }

    override func resourceAttributes(atPath path: String!) throws -> [AnyHashable : Any] {
        guard path == helloPath,
            let url = Bundle.main.url(forResource: "hellodoc", withExtension: "icns") else {
            throw NSError()
        }
        let data = try Data(contentsOf: url)
        return [kGMUserFileSystemCustomIconDataKey: data]
    }
}
