//
//  Extentions.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import SwiftUI
import Foundation

struct Palette: Codable {
    var palIdx: Int
    var palName: String
    var palColors: [String: PaletteColor]
}

struct PaletteColor: Codable {
    var colIdx: Int
    var colName: String
    var colColor: SerializableColor
}

//struct PaletteData: Codable {
//    var idx: Int
//    var palette: [String: ColorData]
//}
//
//struct ColorData: Codable {
//    var idx: Int
//    var color: SerializableColor
//}

struct SerializableColor: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double?
    
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
            return "\(String(format:"%02X", Int(red * 255)))\(String(format:"%02X", Int(green * 255)))\(String(format:"%02X", Int(blue * 255)))\(String(format:"%02X", Int(alpha == nil ? 1 : alpha! * 255)))"
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
        return Color(red: red, green: green, blue: blue, opacity: alpha ?? 1)
    }
}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension Strideable where Stride: SignedInteger {
    func clamped(to limits: CountableClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

func ShowInFinder(url: URL?){
    guard let url = url else { return }

    NSWorkspace.shared.activateFileViewerSelecting([url])
}
//extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}

func assetFilesDirectory(name: String, shouldCreate: Bool) -> URL? {
    do {
        let applicationSupportFolderURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let folder = applicationSupportFolderURL.appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: folder.path) {
            if shouldCreate {
                try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
            } else {
                return nil
            }
        }

        return folder
    } catch {
        print(error)
        return nil
    }
}
