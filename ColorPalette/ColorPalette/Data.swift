//
//  Data.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.11.20.
//

import Foundation
import SwiftUI


// MARK: OBSERVABLE OBJECT
class PalettesOO: ObservableObject {
    @Published var palettes = [Palette]()
}

// MARK: Palette
struct Palette: Codable {
    var palName: String
    var palColors: [PaletteColor]
}


// MARK: Palette Color
struct PaletteColor: Codable {
    var colName: String
    var colColor: SerializableColor
}


// MARK: Serializeable Color
extension Color {
    func GetSerializeableColor() -> SerializableColor {
        let com = self.cgColor?.components!
        if com?.count == 4 {
            return SerializableColor(red: Double(com![0]), green: Double(com![1]), blue: Double(com![2]), alpha: Double(com![3]))
        }
        else {
            return SerializableColor(red: Double(com![0]), green: Double(com![1]), blue: Double(com![2]), alpha: 0)
        }
    }
}
struct SerializableColor: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double?
    
    init() {
        red = 0
        green = 0
        blue = 0
        alpha = 1
    }
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = 1
    }
    init(red: Double, green: Double, blue: Double, alpha: Double?) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    init(color: Color) {
        let c = color.cgColor!.components!
        self.red = Double(c[0])
        self.green = Double(c[1])
        self.blue = Double(c[2])
        if c.count > 3 {
            self.alpha = Double(c[0])
        }
        else {
            self.alpha = 1
        }
    }
    
    var red255: Double {
        get { return red * 255 }
        set { red = newValue / 255}
    }
    var green255: Double {
        get { return green * 255 }
        set { green = newValue / 255}
    }
    var blue255: Double {
        get { return blue * 255 }
        set { blue = newValue / 255}
    }
    var alpha255: Double? {
        get {
            if alpha == nil { return nil }
            return alpha! * 255
        }
        set {
            if newValue == nil { alpha = nil }
            alpha = newValue! / 255
        }
    }
    
    var hex: String {
        get {
            return "\(String(format:"%02X", Int(red * 255)))\(String(format:"%02X", Int(green * 255)))\(String(format:"%02X", Int(blue * 255)))"
        }
        set {
            var val = newValue
            if newValue.hasPrefix("#") {
                val = newValue.substring(with: 1..<newValue.count)
            }
            if val.count == 8 {
                hexA = val
                return
            }
            if val.count != 6 {
                return
            }
            red     = Double(Int(val.substring(with: 0..<2), radix: 16)!) / Double(255)
            green   = Double(Int(val.substring(with: 2..<4), radix: 16)!) / Double(255)
            blue    = Double(Int(val.substring(with: 4..<6), radix: 16)!) / Double(255)
        }
    }
    var hexA: String {
        get {
            return "\(String(format:"%02X", Int(red * 255)))\(String(format:"%02X", Int(green * 255)))\(String(format:"%02X", Int(blue * 255)))\(String(format: "%02X", Int(alpha == nil ? 255 : alpha! * 255)))"
        }
        set {
            var val = newValue
            if newValue.hasPrefix("#") {
                val = newValue.substring(with: 1..<newValue.count)
            }
            if val.count == 6 {
                val.append("ff")
            }
            if val.count != 8 {
                return
            }
            red     = Double(Int(val.substring(with: 0..<2), radix: 16)!) / Double(255)
            green   = Double(Int(val.substring(with: 2..<4), radix: 16)!) / Double(255)
            blue    = Double(Int(val.substring(with: 4..<6), radix: 16)!) / Double(255)
            alpha   = Double(Int(val.substring(with: 6..<8), radix: 16)!) / Double(255)
        }
    }

    var color: Color {
        get {
            return Color(red: red, green: green, blue: blue, opacity: alpha ?? 1)
        }
        set {
            let c = newValue.cgColor!.components!
            self.red = Double(c[0])
            self.green = Double(c[1])
            self.blue = Double(c[2])
            if c.count > 3 {
                self.alpha = Double(c[3])
            }
            else {
                self.alpha = nil
            }
        }
    }
    var colorNA: Color {
        return Color(red: red, green: green, blue: blue, opacity: 1)
    }
}
