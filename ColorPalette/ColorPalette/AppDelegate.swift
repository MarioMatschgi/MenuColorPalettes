//
//  AppDelegate.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    static var instance: AppDelegate?
    static var popover: NSPopover!
    static var statusBarItem: NSStatusItem!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.instance = self
        
        // Load Palettes
        Manager.LoadPalettes()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = MenuItemView()
        
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        AppDelegate.popover = popover
        
        // Create the status item
        AppDelegate.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = AppDelegate.statusBarItem.button {
             button.image = NSImage(named: "Icon")
            button.action = #selector(togglePopover(_:))
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
         if let button = AppDelegate.statusBarItem.button {
              if AppDelegate.popover.isShown {
                AppDelegate.popover.performClose(sender)
              } else {
                AppDelegate.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
              }
         }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

