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
    
    var hex: String {
        return "\(String(format:"%02X", Int(red * 255)))\(String(format:"%02X", Int(green * 255)))\(String(format:"%02X", Int(blue * 255)))"
    }
    var hexA: String {
        return "\(String(format:"%02X", Int(red * 255)))\(String(format:"%02X", Int(green * 255)))\(String(format:"%02X", Int(blue * 255)))\(String(format:"%02X", Int(alpha! * 255)))"
    }

    var color: Color {
        return Color(red: red, green: green, blue: blue, opacity: alpha ?? 1)
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
