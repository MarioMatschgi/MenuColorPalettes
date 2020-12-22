//
//  Manager.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.11.20.
//

import Foundation
import SwiftUI

class Manager {
    static let k_hideDockIcon = "hideDockIcon"
    static let k_paletteIndicies = "palettes.indicies"
    
    static let k_menu_grid_colCount = "menu.grid.colCount"
    static let k_menu_grid_cell_size = "menu.grid.cell.size"
    static let k_menu_grid_cell_spacing = "menu.grid.cell.spacing"
    static let k_menu_grid_cell_radius = "menu.grid.cell.radius"
    
    static let k_menu_cell_colCount = "menu.cell.colCount"
    
    static let k_view_grid_colCount = "view.grid.colCount"
    static let k_view_grid_cell_size = "view.grid.cell.size"
    static let k_view_grid_cell_spacing = "view.grid.cell.spacing"
    static let k_view_grid_cell_radius = "view.grid.cell.radius"
    
//    static var palettesOpen = [Palette:NSWindow]()
    
    
    // MARK: Setup
    static func Setup() {
//        UserDefaults.resetDefaults()
        
        // Userdefaults
        if UserDefaults.standard.object(forKey: k_hideDockIcon) == nil {
            UserDefaults.standard.setValue(false, forKey: k_hideDockIcon)
        }
        
        if UserDefaults.standard.object(forKey: k_menu_grid_colCount) == nil {
            UserDefaults.standard.setValue(4, forKey: k_menu_grid_colCount)
        }
        if UserDefaults.standard.object(forKey: k_menu_grid_cell_size) == nil {
            UserDefaults.standard.setValue(Float(100), forKey: k_menu_grid_cell_size)
        }
        if UserDefaults.standard.object(forKey: k_menu_grid_cell_spacing) == nil {
            UserDefaults.standard.setValue(Float(25), forKey: k_menu_grid_cell_spacing)
        }
        if UserDefaults.standard.object(forKey: k_menu_grid_cell_radius) == nil {
            UserDefaults.standard.setValue(Float(25), forKey: k_menu_grid_cell_radius)
        }
        
        if UserDefaults.standard.object(forKey: k_menu_cell_colCount) == nil {
            UserDefaults.standard.setValue(5, forKey: k_menu_cell_colCount)
        }
        
        if UserDefaults.standard.object(forKey: k_view_grid_colCount) == nil {
            UserDefaults.standard.setValue(6, forKey: k_view_grid_colCount)
        }
        if UserDefaults.standard.object(forKey: k_view_grid_cell_size) == nil {
            UserDefaults.standard.setValue(Float(100), forKey: k_view_grid_cell_size)
        }
        if UserDefaults.standard.object(forKey: k_view_grid_cell_spacing) == nil {
            UserDefaults.standard.setValue(Float(25), forKey: k_view_grid_cell_spacing)
        }
        if UserDefaults.standard.object(forKey: k_view_grid_cell_radius) == nil {
            UserDefaults.standard.setValue(Float(25), forKey: k_view_grid_cell_radius)
        }
        
        SetDockVisibility(visible: !UserDefaults.standard.bool(forKey: k_hideDockIcon))
        
        var testPalette = Palette(palName: "TestPalette", palColors: [])
        testPalette.palColors.append(PaletteColor(colName: "Color1", colColor: SerializableColor(red: 1, green: 0, blue: 0, alpha: 1)))
        testPalette.palColors.append(PaletteColor(colName: "Color2", colColor: SerializableColor(red: 0, green: 1, blue: 0, alpha: 1)))
        testPalette.palColors.append(PaletteColor(colName: "Color3", colColor: SerializableColor(red: 0, green: 0, blue: 1, alpha: 1)))
        SavePalette(palette: testPalette)
        
        testPalette = Palette(palName: "TestPalette2", palColors: [])
        testPalette.palColors.append(PaletteColor(colName: "Color1", colColor: SerializableColor(red: 1, green: 0, blue: 0, alpha: 1)))
        testPalette.palColors.append(PaletteColor(colName: "Color2", colColor: SerializableColor(red: 0, green: 1, blue: 0, alpha: 1)))
        testPalette.palColors.append(PaletteColor(colName: "Color3", colColor: SerializableColor(red: 0, green: 0, blue: 1, alpha: 1)))
        testPalette.palColors.append(PaletteColor(colName: "Color4", colColor: SerializableColor(red: 1, green: 0, blue: 0, alpha: 1)))
        testPalette.palColors.append(PaletteColor(colName: "Color5", colColor: SerializableColor(red: 0, green: 1, blue: 0, alpha: 1)))
        testPalette.palColors.append(PaletteColor(colName: "Color6", colColor: SerializableColor(red: 0, green: 0, blue: 1, alpha: 1)))
        SavePalette(palette: testPalette)
        
        LoadAllPalettes()
    }
    
    static func AddNewPalette(name: String) {
        let palette = Palette(palName: name, palColors: [])
        SavePalette(palette: palette)
        
        AppDelegate.menuItemView.palettesOO.palettes.append(palette)
    }
    
    
    // MARK: Palettes
    static func ViewPalette(pal: Binding<Palette>) {
        let win = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 480, height: 300), styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView, .nonactivatingPanel], backing: .buffered, defer: false)
        win.isReleasedWhenClosed = false
        win.center()
        win.title = "Viewing: \(pal.palName.wrappedValue)"
        win.setFrameAutosaveName(win.title)
        win.contentView = NSHostingView(rootView: PaletteView(palette: pal))
        win.makeKeyAndOrderFront(nil)
        win.level = .floating
        
        win.makeKey()
        
//        palettesOpen.append(win, forKey: pal)
    }
    
    static func LoadAllPalettes() {
        AppDelegate.menuItemView.palettesOO.palettes = [Palette]()
        var palettesLoaded = [Palette]()
        
        // Load all palettes from folder
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: (assetFilesDirectory(name: "Palettes", shouldCreate: true)?.path)!)
            for item in items {
                if !item.hasSuffix(".json") {
                    continue
                }
                
                let pal = LoadPalette(palName: item.replacingOccurrences(of: ".json", with: ""))
                if pal != nil {
                    palettesLoaded.append(pal!)
                }
            }
        } catch { print("Failed to read directory: \(error.localizedDescription)") }
        
        // Sort array by index of user defaults
        var palettes = [Palette]()
        for _ in 0..<palettesLoaded.count {
            palettes.append(Palette(palName: "", palColors: []))
        }
        var palettesNew = [Palette]()
        var idx = 0
        for palette in palettesLoaded {
            
                palettesNew.append(palette)
//            if UserDefaults.standard.object(forKey: "\(k_paletteIndicies).\(palette.palName)") == nil || UserDefaults.standard.integer(forKey: "\(k_paletteIndicies).\(palette.palName)") >= palettes.count {
//                palettesNew.append(palette)
//            } else {
//                print("I \(UserDefaults.standard.integer(forKey: "\(k_paletteIndicies).\(palette.palName)")) C \(palettes.count)")
//                palettes[UserDefaults.standard.integer(forKey: "\(k_paletteIndicies).\(palette.palName)")] = palette
//                idx += 1
//            }
        }
        palettes.removeSubrange(idx..<palettes.count)
        for palette in palettesNew {
            AddPalette(palette: palette)
        }
        
        print("Successfully loaded all(\(palettes.count)) color palettes!")
    }
    
    static func AddPalette(palette: Palette) {
        AppDelegate.menuItemView.palettesOO.palettes.append(palette)
        
        UserDefaults.standard.setValue(AppDelegate.menuItemView.palettesOO.palettes.count - 1, forKey: "\(k_paletteIndicies).\(palette.palName)")
        SavePalette(palette: palette)
    }
    
    static func SavePalette(palette: Palette) {
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
        dump(palette.palColors)
    }
    
    static func LoadPalette(palName: String) -> Palette? {
        var palette: Palette?
        
        var url = assetFilesDirectory(name: "Palettes", shouldCreate: true)
        url?.appendPathComponent("\(palName).json")
        
        var json = ""
        do { json = try String(contentsOf: url!, encoding: .utf8) } catch { print("Failed to load file \(palName).json : \(error.localizedDescription)") }
        
        
        let decoder = JSONDecoder()
        do {
            palette = try decoder.decode(Palette.self, from: json.data(using: .utf8)!)
        }
        catch { print("Failed to decode file \(palName).json : \(error.localizedDescription)") }
        
        palette?.palName = palName  // Set palName to filename so the user can change palette name by changing filename
        
        return palette
    }
    
    static func RemovePalette(name: String) {
        var url = assetFilesDirectory(name: "Palettes", shouldCreate: true)
        url?.appendPathComponent("\(name).json")
        if (url == nil) {
            return
        }

        do {
            try FileManager.default.removeItem(at: url!)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
        
        LoadAllPalettes()
        UserDefaults.standard.removeObject(forKey: "\(k_paletteIndicies).\(name)")
    }
    
    
    // MARK: Preferences
    private static var preferencesWindow: NSWindow?
    static func OpenPreferences() {
        preferencesWindow = PreferencesWindow()
    }
    
    
    // MARK: Preferences
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
