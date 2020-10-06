//
//  Manager.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import Foundation

class Manager {
    static var palettes = [String: [String: ColorData]]()
    
    static func LoadPalettes() {
        let fm = FileManager.default
        let dir = assetFilesDirectory(name: "Palettes", shouldCreate: true)
        
        
        do {
            let items = try fm.contentsOfDirectory(atPath: (dir?.path)!)

            for item in items {
                var url = dir
                url?.appendPathComponent(item)
                
                var json = ""
                do {
                    json = try String(contentsOf: url!, encoding: .utf8)
                }
                catch {/* error handling here */}
                
                
                let decoder = JSONDecoder()
                do {
                    let dict = try decoder.decode(Dictionary<String, ColorData>.self, from: json.data(using: .utf8)!)
                    
                    palettes[item.replacingOccurrences(of: ".json", with: "")] = dict
                }
                catch {/* error handling here */}
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
            print("\(error)")
        }
        
        for (pal, dict) in palettes {
            for (name, colorData) in dict {
                print("Pal: \(pal) Nam: \(name) Col: \(colorData)")
            }
        }
    }
    
    static func AddPalette(name: String, dict: [String: ColorData]) {
        // Encode to JSON
        var jsonData = ""
        let encoder = JSONEncoder()
        if let jsonDataL = try? encoder.encode(dict) {
            if let jsonString = String(data: jsonDataL, encoding: .utf8) {
                jsonData = jsonString
            }
        }
        
        // Save to file
        let dataToSave = jsonData
        let url = assetFilesDirectory(name: "Palettes", shouldCreate: true)
        do {
            try dataToSave.write(to: (url?.appendingPathComponent("\(name).json"))!, atomically: true, encoding: .utf8)
        } catch {
            // Handle error
        }
        
        // Reload Palettes
        LoadPalettes()
    }
}
