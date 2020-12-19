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
    
    static let k_viewCellSize = "menu.view.cellSize"
    static let k_viewCellSpacing = "menu.view.cellSpacing"
    static let k_viewCellRadius = "menu.view.cellRadius"
    static let k_viewColCount = "menu.view.colCount"
    
    static let k_previewColCount = "menu.preview.colCount"
    
//    static var palettes = [Palette]()
    
    
    // MARK: Setup
    static func Setup() {
        // Userdefaults
        if UserDefaults.standard.object(forKey: k_hideDockIcon) == nil {
            UserDefaults.standard.setValue(false, forKey: k_hideDockIcon)
        }
        if UserDefaults.standard.object(forKey: k_viewCellSize) == nil {
            UserDefaults.standard.setValue(Float(100), forKey: k_viewCellSize)
        }
        if UserDefaults.standard.object(forKey: k_viewCellSpacing) == nil {
            UserDefaults.standard.setValue(Float(25), forKey: k_viewCellSpacing)
        }
        if UserDefaults.standard.object(forKey: k_viewCellRadius) == nil {
            UserDefaults.standard.setValue(Float(25), forKey: k_viewCellRadius)
        }
        if UserDefaults.standard.object(forKey: k_viewColCount) == nil {
            UserDefaults.standard.setValue(4, forKey: k_viewColCount)
        }
        
        if UserDefaults.standard.object(forKey: k_previewColCount) == nil {
            UserDefaults.standard.setValue(5, forKey: k_previewColCount)
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
        
        // Update palettes
        print("CMEN \(AppDelegate.menuItemView.palettesOO.palettes.count) CMAN \(palettes.count)")
        
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
//        AppDelegate.menuItemView.palettesOO.palettes.remove(at: UserDefaults.standard.integer(forKey: "\(k_paletteIndicies).\(name)"))
//        AppDelegate.menuItemView.palettesOO.palettes.removeLast()
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
