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
            let color = SerializableColor(red: Double(colors![0])!/255, green: Double(colors![1])!/255, blue: Double(colors![2])!/255, alpha: 1)
            
            
            var nameString = element.slice(from: "<span", to: "/span>")
            nameString = nameString?.slice(from: ">", to: "<")
            
            palColors[nameString!] = PaletteColor(colIdx: idx, colName: nameString!, colColor: color)
            
            
            idx += 1
        }
        
        return Palette(palIdx: -1, palName: name, palColors: palColors)
    }
    
    static func LoadPalettes() {
        palettes = [String: Palette]()
        
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
        
        Manager.LoadUserDefaults()
        
        SendPublisher()
    }
    
    static func LoadUserDefaults() {
        for (palName, _) in palettes {
            if UserDefaults.standard.object(forKey: "\(palName).colFormatIdx") == nil {
                UserDefaults.standard.setValue(0, forKey: "\(palName).colFormatIdx")
            }
            if UserDefaults.standard.object(forKey: "\(palName).palColCount") == nil {
                UserDefaults.standard.setValue(5, forKey: "\(palName).palColCount")
            }
            if UserDefaults.standard.object(forKey: "\(palName).palCellSize") == nil {
                UserDefaults.standard.setValue(100, forKey: "\(palName).palCellSize")
            }
            if UserDefaults.standard.object(forKey: "\(palName).palCellRad") == nil {
                UserDefaults.standard.setValue(25, forKey: "\(palName).palCellRad")
            }
        }
    }
    
    private static func SendPublisher() {
        MenuItemView.instance?.palCountPublisher.send(palettes.count)
    }
    
    static func GetPaletteNameByIndex(idx: Int) -> String {
        for (palName, pal) in palettes {
            if pal.palIdx == idx {
                return palName
            }
        }
        
        return ""
    }
    
    static func GetPaletteByIndex(idx: Int) -> Palette {
        return palettes[GetPaletteNameByIndex(idx: idx)]!
    }
    
    static func GetColorNameByIndex(idx: Int, palette: Palette) -> String {
        for (colName, col) in palette.palColors {
            if col.colIdx == idx {
                return colName
            }
        }
        
        return ""
    }
    
    static func AddPalette(palette: Palette) {
        var palToSave = palette
        palToSave.palIdx = palettes.count
        
        // Encode to JSON
        var jsonData = ""
        let encoder = JSONEncoder()
        if let jsonDataL = try? encoder.encode(palToSave) {
            if let jsonString = String(data: jsonDataL, encoding: .utf8) {
                jsonData = jsonString
            }
        }
        
        // Save to file
        let dataToSave = jsonData
        let url = assetFilesDirectory(name: "Palettes", shouldCreate: true)
        do {
            try dataToSave.write(to: (url?.appendingPathComponent("\(palToSave.palName).json"))!, atomically: true, encoding: .utf8)
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
    
    static func RenamePalette(oldName: String, newName: String) {
        var palette = palettes[oldName]
        palette?.palName = newName
        RemovePalette(name: oldName)
        AddPalette(palette: palette!)
    }
    
    static var window: NSWindow? = nil
    static func OpenWindow(type: WindowType, palette: Palette? = nil) {
        // Create the window and set the content view.
        if window != nil && type != .PaletteViewWindow {
            window?.close()
        }
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window?.isReleasedWhenClosed = false
        window?.center()
        window?.title = GetWindowTitle(type: type, palette: palette)
        window?.setFrameAutosaveName(window!.title)
        window?.contentView = GetContentView(type: type, palette: palette)
        window?.makeKeyAndOrderFront(nil)
        window?.level = .floating
        
        window?.makeKey()
    }
    private static func GetContentView(type: WindowType, palette: Palette?) -> NSView {
        switch type {
            case .PaletteAddWindow:
                return NSHostingView(rootView: AddPaletteView())
            case .PaletteEditWindow:
                return NSHostingView(rootView: EditPaletteView(palette: palette!))
            case .PaletteViewOptions:
                return NSHostingView(rootView: PaletteViewOptionsView(palette: palette!))
            case .PaletteViewWindow:
                return NSHostingView(rootView: PaletteView(palette: palette!))
        }
    }
    private static func GetWindowTitle(type: WindowType, palette: Palette?) -> String {
        switch type {
            case .PaletteAddWindow:
                return "Add palette"
            case .PaletteEditWindow:
                return "Manage palettes"
            case .PaletteViewOptions:
                return "Palette options"
            case .PaletteViewWindow:
                return "View palette \((palette?.palName)!)"
        }
    }
    
    enum WindowType {
        case PaletteAddWindow
        case PaletteEditWindow
        case PaletteViewOptions
        case PaletteViewWindow
    }
}
