//
//  AppDelegate.swift
//  HelloFS-Swift
//
//  Created by Gunnar Herzog on 28/09/2016.
//
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private lazy var helloFS = HelloFSFileSystem()
    private lazy var userFileSystem: GMUserFileSystem = { [unowned self] in
        return GMUserFileSystem(delegate: self.helloFS, isThreadSafe: true)
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NotificationCenter.default.addObserver(self, selector: #selector(didMount(notification:)), name: Notification.Name(kGMUserFileSystemDidMount), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUnmount(notification:)), name: Notification.Name(kGMUserFileSystemDidUnmount), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(mountFailed(notification:)), name: Notification.Name(kGMUserFileSystemMountFailed), object: nil)

        userFileSystem.mount(atPath: "/Volumes/Hello", withOptions: ["volname=HelloFS-Swift", "rdonly", String(format: "volicon=%@", Bundle.main.path(forResource: "Fuse", ofType: "icns")!)])
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        NotificationCenter.default.removeObserver(self)
        userFileSystem.unmount()
        return .terminateNow
    }

    func didMount(notification: Notification) {
        print("didMount")
        guard let userInfo = notification.userInfo,
             let mountPath = userInfo[kGMUserFileSystemMountPathKey] as? String else {
                return
        }

        let parentPath = (mountPath as NSString).deletingLastPathComponent
        NSWorkspace.shared().selectFile(mountPath, inFileViewerRootedAtPath: parentPath)
    }

    func didUnmount(notification: Notification) {
        print("didUnmount")
        NSApplication.shared().terminate(nil)
    }

    func mountFailed(notification: Notification) {
        print("mountFailed")
    }
}
