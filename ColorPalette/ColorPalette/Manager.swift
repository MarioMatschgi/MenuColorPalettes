//
//  Manager.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import Foundation
import SwiftUI

class Manager {
    static var palettes = [String: Palette]()
    
    
    static func GeneratePaletteByHTML(name: String, html: String) -> Palette {
        var palColors = [String: PaletteColor]()
        
        // HTML to dict
        let htmlArr = html.components(separatedBy: "</div>")
        var idx = 0
        for element in htmlArr {
            let colorString = element.slice(from: "background-color: ", to: ";")?.replacingOccurrences(of: "rgb(", with: "").replacingOccurrences(of: ")", with: "")
            if colorString == nil {
                continue
            }
            let colors = colorString?.components(separatedBy: ", ")
            let color = SerializableColor(red: Double(colors![0])!, green: Double(colors![1])!, blue: Double(colors![2])!, alpha: 1)
            
            
            var nameString = element.slice(from: "<span", to: "/span>")
            nameString = nameString?.slice(from: ">", to: "<")
            
            palColors[nameString!] = PaletteColor(colIdx: idx, colName: nameString!, colColor: color)
            
            
            idx += 1
        }
        
        return Palette(palIdx: -1, palName: name, palColors: palColors)
    }
    
    static func LoadPalettes() {
        let fm = FileManager.default
        let dir = assetFilesDirectory(name: "Palettes", shouldCreate: true)
        
        
        do {
            let items = try fm.contentsOfDirectory(atPath: (dir?.path)!)

            for item in items {
                if !item.hasSuffix(".json") {
                    continue
                }
                
                var url = dir
                url?.appendPathComponent(item)
                
                var json = ""
                do { json = try String(contentsOf: url!, encoding: .utf8) } catch {/* error handling here */}
                
                
                let decoder = JSONDecoder()
                do {
                    let palette = try decoder.decode(Palette.self, from: json.data(using: .utf8)!)
                    
                    palettes[item.replacingOccurrences(of: ".json", with: "")] = palette
                }
                catch { print("Failed to decode file \(item) : \(error.localizedDescription)") }
            }
        } catch { print("Failed to read directory: \(error.localizedDescription)") }
        
        print("Successfully loaded all(\(palettes.count)) color palettes!")
        
//        MenuContentView.instance?.palCount = palettes.count
    }
    
    static func GetPaletteNameByIndex(idx: Int) -> String {
//        for (pal, dict) in palettes {
//            for (name, colorData) in dict {
//                if
//            }
//        }
        
        return ""
    }
    
    static func AddPalette(palette: Palette) {
        // Encode to JSON
        var jsonData = ""
        let encoder = JSONEncoder()
        if let jsonDataL = try? encoder.encode(palette) {
            if let jsonString = String(data: jsonDataL, encoding: .utf8) {
                jsonData = jsonString
            }
        }
        
        // Save to file
        let dataToSave = jsonData
        let url = assetFilesDirectory(name: "Palettes", shouldCreate: true)
        do {
            try dataToSave.write(to: (url?.appendingPathComponent("\(palette.palName).json"))!, atomically: true, encoding: .utf8)
        } catch {
            // Handle error
        }
        
        // Reload Palettes
        LoadPalettes()
    }
    
    static func RemovePalette(name: String) {
        let fm = FileManager.default
        let dir = assetFilesDirectory(name: "Palettes", shouldCreate: true)
        
        do {
            try fm.removeItem(at: (dir?.appendingPathComponent("\(name).json"))!)
        }
        catch {
            // Handle error
        }
        
        // Reload Palettes
        LoadPalettes()
    }
    
    static var window: NSWindow? = nil
    static func OpenWindow(type: WindowType) {
        // Create the window and set the content view.
        if window != nil {
            window?.close()
        }
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window?.isReleasedWhenClosed = false
        window?.center()
        window?.setFrameAutosaveName("\(type)")
        window?.contentView = GetContentView(type: type)
        window?.makeKeyAndOrderFront(nil)
        window?.level = .floating
        window?.title = GetWindowTitle(type: type)
    }
    private static func GetContentView(type: WindowType) -> NSView {
        switch type {
        case .PaletteManagingWindow:
            return NSHostingView(rootView: EditContentView())
        }
    }
    private static func GetWindowTitle(type: WindowType) -> String {
        switch type {
        case .PaletteManagingWindow:
            return "Manage Palettes"
        }
    }
    
    enum WindowType {
        case PaletteManagingWindow
    }
}
