//
//  AppDelegate.swift
//  MyWebSite
//
//  Created by blackdwarf on 16/8/2023.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var areWindowsHidden = false

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        toggleAllWindows()
        return true
    }

    private func toggleAllWindows() {
        for window in NSApplication.shared.windows {
            if areWindowsHidden {
                window.makeKeyAndOrderFront(self)
            } else {
                window.orderOut(self)
            }
        }
        areWindowsHidden.toggle()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

}
