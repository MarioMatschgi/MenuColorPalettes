//
//  Manager.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.11.20.
//

import Foundation
import SwiftUI

class Manager {
    static var k_hideDockIcon = "hideDockIcon"
    
    static func Setup() {
        if UserDefaults.standard.object(forKey: k_hideDockIcon) == nil {
            UserDefaults.standard.setValue(false, forKey: k_hideDockIcon)
        }
        
        SetDockVisibility(visible: !UserDefaults.standard.bool(forKey: k_hideDockIcon))
    }
    
    private static var preferencesWindow: NSWindow?
    static func OpenPreferences() {
        preferencesWindow = PreferencesWindow()
    }
    
    static func ForceSetDockVisibility(visible: Bool) {
        NSApp.setActivationPolicy(visible ? .regular : .accessory)
    }
    private static var dockTimer: Timer?
    static func SetDockVisibility(visible: Bool) {
        dockTimer?.invalidate()
        dockTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            // toggle dock icon shown/hidden.
            ForceSetDockVisibility(visible: visible)
        })
    }
}
