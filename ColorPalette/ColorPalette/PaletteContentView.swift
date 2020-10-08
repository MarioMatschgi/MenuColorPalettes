//
//  PaletteContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 07.10.20.
//
//

import SwiftUI
import Combine

struct PaletteContentView: View {
    var palette: Palette
    var colorFormat: String {
        return formats[selection]
    }
    
    // Grid stuff
    @State var colCount: Int = 20
    var palCountPublisher = PassthroughSubject<Int, Never>()
    let panelPadding = CGFloat(10)
    let panelMargin = CGFloat(10)
    let panelRadius = CGFloat(25)
    let cellSize = CGFloat(100)
    let cellPadding = CGFloat(5)
    let paletteColumns = 5
    let aColor = Color(red: 0/255, green: 152/255, blue: 0/255)
    func GetForBounds(row: Int) -> Int {
        return min(colCount-(row * paletteColumns), paletteColumns)
    }
    
    @State private var selection: Int = 0
    init(palette: Palette) {
//        self.colorFormat = "§r, §g, §b, §a, §hex, §#hex, §hexA, §#hexA" // ToDo: Load from user defaults
        
        self.palette = palette
        
        self.colCount = palette.palColors.count
    }
    
    @State private var formats = [
        "§r, §g, §b",
        "§r, §g, §b, §a",
        "§hex",
        "§#hex",
        "§hexA",
        "§#hexA",
    ]
    var body: some View {
        VStack {
            //
            Text("Color palette \(palette.palName)")
            Text("\(palette.palColors.count)")
            Picker(selection: $selection.onChange({ newSelection in
                UserDefaults.standard.setValue(newSelection, forKey: "\(palette.palName).colFormatIdx")
            }), label: Text("Copy format")) {
                ForEach (0..<formats.count, id: \.self) {
                    idx in
                    Text(formats[idx].replacingOccurrences(of: "§", with: "")).tag(idx)
                }
            }.onAppear() {
                self.selection = UserDefaults.standard.integer(forKey: "\(palette.palName).colFormatIdx").clamped(to: 0...formats.count-2)
            }
            
            Spacer()
            
            VStack {
                ForEach (0..<(colCount / paletteColumns) + 1, id: \.self) {
                    row in
                    HStack {
                        ForEach (0..<GetForBounds(row: row), id: \.self) {
                            col in
                            VStack {
                                Button(action: { CopyColor(colName: Manager.GetColorNameByIndex(idx: row * paletteColumns + col, palette: palette)) }) {
                                    VStack{ // ToDo: Replace with custom "Preview Stack"
                                        
                                    }.frame(width: cellSize, height: cellSize).background(RoundedRectangle(cornerRadius: panelRadius).fill(GetCol(idx: row * paletteColumns + col)))
                                }.buttonStyle(PlainButtonStyle()).frame(width: cellSize, height: cellSize).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                
                                Text("\(Manager.GetColorNameByIndex(idx: row * paletteColumns + col, palette: palette))")
                            }.padding(cellPadding)
                        }
                    }
                }
            }
        }.fixedSize().padding(20)
    }
    
    func GetCol(idx: Int) -> Color {
        return palette.palColors[Manager.GetColorNameByIndex(idx: idx, palette: palette)]!.colColor.color
    }
    
    func CopyColor(colName: String) {
        let sColor = palette.palColors[colName]?.colColor
        
        let colorFormatted = colorFormat
            .replacingOccurrences(of: "§r01", with: "\(sColor!.red)")
            .replacingOccurrences(of: "§g01", with: "\(sColor!.green)")
            .replacingOccurrences(of: "§b01", with: "\(sColor!.blue)")
            .replacingOccurrences(of: "§a01", with: "\(sColor!.alpha)")
            .replacingOccurrences(of: "§r", with: "\(Int(sColor!.red * 255))")
            .replacingOccurrences(of: "§g", with: "\(Int(sColor!.green * 255))")
            .replacingOccurrences(of: "§b", with: "\(Int(sColor!.blue * 255))")
            .replacingOccurrences(of: "§a", with: "\(Int(sColor!.alpha! * 255))")
            .replacingOccurrences(of: "§#hex", with: "#\(sColor!.hex)")
            .replacingOccurrences(of: "§hex", with: "\(sColor!.hex)")
            .replacingOccurrences(of: "§#hexA", with: "#\(sColor!.hexA)")
            .replacingOccurrences(of: "§hexA", with: "\(sColor!.hexA)")
        print(colorFormatted)
        
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(colorFormatted, forType: .string)
    }
}


struct PaletteContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PaletteContentView(palette: Manager.palettes[Manager.GetPaletteNameByIndex(idx: 0)]!)
        }
    }
}
