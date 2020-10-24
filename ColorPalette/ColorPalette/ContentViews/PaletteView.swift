//
//  PaletteContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 07.10.20.
//
//

import SwiftUI
import Combine

// MARK: PALLETTE-VIEW
/// PaletteView: The View for viewing a Palette
struct PaletteView: View {
    @State var palette: Palette
    var colorFormat: String {
        return formats[selection]
    }
    
    @State var isAddingColor = false
    
    // Grid stuff
    @State var paletteColumns = 5
    
    var palCountPublisher = PassthroughSubject<Int, Never>()
    let panelPadding = CGFloat(10)
    let panelMargin = CGFloat(10)
    @State var cellRadius = CGFloat(25)
    @State var cellSize = CGFloat(100)
    let cellPadding = CGFloat(5)
    
    func GetOuterForBounds() -> Int {
        return ((palette.palColors.count + 1) / paletteColumns) + 1
    }
    func GetInnerForBounds(row: Int) -> Int {
        return min(palette.palColors.count + 1 - (row * paletteColumns), paletteColumns)
    }
    func IsLastCell(row: Int, col: Int) -> Bool {
        return (row == GetOuterForBounds() - 1 && col == GetInnerForBounds(row: row) - 1)
    }
    
    @State private var selection: Int = 0
    
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
            HStack {
                Picker(selection: $selection.onChange({ newSelection in
                    UserDefaults.standard.setValue(newSelection, forKey: "\(palette.palName).colFormatIdx")
                }), label: Text("Copy format").frame(minWidth: 100, alignment: .leading)) {
                    ForEach (0..<formats.count, id: \.self) {
                        idx in
                        Text(formats[idx].replacingOccurrences(of: "§", with: "")).tag(idx)
                    }
                }.frame(minWidth: 250)
                .onAppear() {
                    self.selection = UserDefaults.standard.integer(forKey: "\(palette.palName).colFormatIdx").clamped(to: 0...formats.count-2)
                }
                Button(action: {
                    Manager.OpenWindow(type: .PaletteViewOptions, palette: palette)
                }) {
                    Text("Palette options")
                }
            }
            
            Spacer()
            
            VStack {
                ForEach (0..<GetOuterForBounds(), id: \.self) {
                    row in
                    HStack {
                        ForEach (0..<GetInnerForBounds(row: row), id: \.self) {
                            col in
                            
                            VStack {
                                if IsLastCell(row: row, col: col) {
                                    if !isAddingColor {
                                        AddItemView(cellSize: cellSize, action: { self.isAddingColor = true })
                                    }
                                }
                                else {
                                    VStack {
                                        Button(action: { CopyColor(colName: Manager.GetColorNameByIndex(idx: row * paletteColumns + col, palette: palette)) }) {
                                            VStack {
                                                
                                            }.frame(width: cellSize, height: cellSize).background(RoundedRectangle(cornerRadius: cellRadius).fill(GetCol(idx: row * paletteColumns + col)))
                                        }.buttonStyle(PlainButtonStyle()).frame(width: cellSize, height: cellSize).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                        
                                        Text("\(Manager.GetColorNameByIndex(idx: row * paletteColumns + col, palette: palette))").fixedSize(horizontal: false, vertical: true)
                                    }.frame(width: cellSize, height: cellSize + 50, alignment: .top).padding(cellPadding)
                                }
                            }
                        }
                    }
                }
            }
            
            if isAddingColor {
                Spacer()
                Divider()
                AddColorView(palette: $palette, isAddingColor: $isAddingColor)
            }
        }.fixedSize().padding()
        .onAppear() {
            self.paletteColumns = UserDefaults.standard.integer(forKey: "\(palette.palName).palColCount")
            self.cellSize = CGFloat(UserDefaults.standard.integer(forKey: "\(palette.palName).palCellSize"))
            self.cellRadius = CGFloat(self.cellSize / 100 * CGFloat(UserDefaults.standard.integer(forKey: "\(palette.palName).palCellRad")))
        }
    }
    
    func GetCol(idx: Int) -> Color {
        if palette.palColors[Manager.GetColorNameByIndex(idx: idx, palette: palette)] == nil {
            return Color.black
        }
        return palette.palColors[Manager.GetColorNameByIndex(idx: idx, palette: palette)]!.colColor.color
    }
    
    func CopyColor(colName: String) {
        let sColor = palette.palColors[colName]?.colColor
        
        let colorFormatted = colorFormat
            .replacingOccurrences(of: "§r01", with: "\(sColor!.red)")
            .replacingOccurrences(of: "§g01", with: "\(sColor!.green)")
            .replacingOccurrences(of: "§b01", with: "\(sColor!.blue)")
            .replacingOccurrences(of: "§a01", with: "\(sColor!.alpha == nil ? 1 : sColor!.alpha!)")
            .replacingOccurrences(of: "§r", with: "\(Int(sColor!.red * 255))")
            .replacingOccurrences(of: "§g", with: "\(Int(sColor!.green * 255))")
            .replacingOccurrences(of: "§b", with: "\(Int(sColor!.blue * 255))")
            .replacingOccurrences(of: "§a", with: "\(Int((sColor!.alpha == nil ? 1 : sColor!.alpha!) * 255))")
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


struct PaletteViewContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PaletteView(palette: Manager.palettes[Manager.GetPaletteNameByIndex(idx: 0)]!)
        }
    }
}
