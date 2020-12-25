//
//  PaletteView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.12.20.
//

import SwiftUI

// MARK: PALETTE-VIEW
struct PaletteView: View {
    @Binding var palette: Palette
    
    @State var colCount = UserDefaults.standard.integer(forKey: Manager.k_view_grid_colCount)
    @State var cellSize = CGFloat(UserDefaults.standard.float(forKey: Manager.k_view_grid_cell_size))
    @State var cellSpacing = CGFloat(UserDefaults.standard.float(forKey: Manager.k_view_grid_cell_spacing))
    @State var cellRadius = CGFloat(UserDefaults.standard.float(forKey: Manager.k_view_grid_cell_radius))
    
    @State var modifyType: ModifyType = .None
    @State var modifyColorIdx = -1
    @State var modifyColorName = ""
    @State var modifyColorColor = Color.white
    
    @State var showOptions = false
    
    @State var updater: Bool = false
    
    @State private var selectedFormatIdx: Int = 0
    @State private var formats = [
        "§r, §g, §b",
        "§r, §g, §b, §a",
        "§hex",
        "#§hex",
        "§hexA",
        "#§hexA",
    ]
    
    var body: some View {
        VStack {
            SectionView2C("Colors", titleContent: {
                HStack {
                    Picker(selection: $selectedFormatIdx.onChange({ newSelection in
                        UserDefaults.standard.setValue(newSelection, forKey: "\(palette.palName).colFormatIdx")
                    }), label: Text("Copy format").frame(minWidth: 100, alignment: .leading)) {
                        ForEach (0..<formats.count, id: \.self) {
                            idx in
                            Text(formats[idx].replacingOccurrences(of: "§", with: "")).tag(idx)
                        }
                    }.frame(minWidth: 250)
                    .onAppear() {
                        self.selectedFormatIdx = UserDefaults.standard.integer(forKey: "\(palette.palName).colFormatIdx").clamped(to: 0...formats.count-2)
                    }
                    Button("\(showOptions ? "Hide" : "Show") options") { showOptions = !showOptions }
                }
            }) {
                VStack {
                    PaletteColorGridView(palette: $palette, colCount: $colCount, cellSize: $cellSize, cellSpacing: $cellSpacing, cellRadius: $cellRadius, modifyType: $modifyType, modifyColorIdx: $modifyColorIdx, modifyColorName: $modifyColorName, modifyColorColor: $modifyColorColor, selectedFormatIdx: $selectedFormatIdx, formats: $formats)
                }
            }
            
            PaletteOptionsView(showOptions: $showOptions, colCount: $colCount, cellSize: $cellSize, cellSpacing: $cellSpacing, cellRadius: $cellRadius)
        }.padding().fixedSize()
    }
}

// MARK: MODIFY-TYPE
enum ModifyType {
    case None
    case Edit
    case Add
}

// MARK: MODIFY-COLOR-VIEW
struct PaletteModifyColorView: View {
    @Binding var palette: Palette
    
    @Binding var modifyType: ModifyType
    @Binding var modifyColorIdx: Int
    @Binding var modifyColorName: String
    @Binding var modifyColorColor: Color
    
    var body: some View {
        VStack {
            if modifyType != .None {
                VStack {
                    Spacer()
                    TextField("Name", text: $modifyColorName)
                    ColorPicker("Color", selection: $modifyColorColor)

                    Spacer().frame(maxHeight: 25)
                    HStack {
                        Button(action: { modifyType = .None }, label: { Text("Cancel") })
                        Spacer()
                        Button(action: {
                            if modifyType == .Edit {
                                print("Changed col: \(modifyColorName) \(modifyColorColor)")
                                
                                palette.palColors[modifyColorIdx].colName = modifyColorName
                                palette.palColors[modifyColorIdx].colColor.color = modifyColorColor
                            }
                            else if modifyType == .Add {
                                print("Added col: \(modifyColorName) \(modifyColorColor)")
                                
                                palette.palColors.append(PaletteColor(colName: modifyColorName, colColor: SerializableColor(color: modifyColorColor)))
                            }
                            else {
                                print("ERROR: Invalid col modifyType!")
                            }
                            
                            Manager.SavePalette(palette: palette)
                            
                            modifyType = .None
                        }, label: { Text("Ok") })
                    }
                }
            }
        }
    }
}

// MARK: COLOR-GRID-VIEW
struct PaletteColorGridView: View {
    @Binding var palette: Palette
    
    @Binding var colCount: Int
    @Binding var cellSize: CGFloat
    @Binding var cellSpacing: CGFloat
    @Binding var cellRadius: CGFloat
    
    @Binding var modifyType: ModifyType
    @Binding var modifyColorIdx: Int
    @Binding var modifyColorName: String
    @Binding var modifyColorColor: Color
    
    @Binding var selectedFormatIdx: Int
    @Binding var formats: [String]
    
    @State var updater: Bool = false
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: colCount), spacing: cellSpacing) {
            ForEach(0..<palette.palColors.count + 1, id: \.self) { idx in
                if (idx >= palette.palColors.count) {
                    Button(action: {
                        modifyColorName = "New color"
                        modifyColorIdx = -1
                            
                        modifyType = .Add
                    }, label: {
                        if modifyType == .Add {
                            PaletteModifyColorView(palette: $palette, modifyType: $modifyType, modifyColorIdx: $modifyColorIdx, modifyColorName: $modifyColorName, modifyColorColor: $modifyColorColor)
                        }
                        else {
                            Image(systemName: "plus.square").font(.system(size: cellSize / 2)).frame(width: cellSize, height: cellSize)
                        }
                    }).buttonStyle(PlainButtonStyle())
                }
                else {
                    Button(action: {
                        CopyColor(col: palette.palColors[idx])
                    }, label: {
                        if modifyType == .Edit && modifyColorIdx == idx {
                            PaletteModifyColorView(palette: $palette, modifyType: $modifyType, modifyColorIdx: $modifyColorIdx, modifyColorName: $modifyColorName, modifyColorColor: $modifyColorColor)
                        }
                        else {
                            VStack {
                                Rectangle().fill(palette.palColors[idx].colColor.colorNA).frame(width: cellSize, height: cellSize).cornerRadius(cellSize / 100 * cellRadius)
                                Text("\(palette.palColors[idx].colName) C \(palette.palColors.count)")
                            }.contextMenu(ContextMenu(menuItems: {
                                Button(action: {
                                    modifyColorName = palette.palColors[idx].colName
                                    modifyColorColor = palette.palColors[idx].colColor.color
                                    modifyColorIdx = idx
                                    
                                    modifyType = .Edit
                                }, label: { Text("Edit") })
                                Button(action: {
                                    palette.palColors.remove(at: idx)
                                    Manager.SavePalette(palette: palette)
                                    updater.toggle()
                                }, label: { Text("Delete") })
                            }))
                        }
                    }).buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    func CopyColor(col: PaletteColor) {
        let sColor = col.colColor
        
        let colorFormatted = formats[selectedFormatIdx]
            .replacingOccurrences(of: "§r01", with: "\(sColor.red)")
            .replacingOccurrences(of: "§g01", with: "\(sColor.green)")
            .replacingOccurrences(of: "§b01", with: "\(sColor.blue)")
            .replacingOccurrences(of: "§a01", with: "\(sColor.alpha == nil ? 1 : sColor.alpha!)")
            
            .replacingOccurrences(of: "§r", with: "\(Int(sColor.red * 255))")
            .replacingOccurrences(of: "§g", with: "\(Int(sColor.green * 255))")
            .replacingOccurrences(of: "§b", with: "\(Int(sColor.blue * 255))")
            .replacingOccurrences(of: "§a", with: "\(Int((sColor.alpha == nil ? 1 : sColor.alpha!) * 255))")
            
            .replacingOccurrences(of: "§hexA", with: "\(sColor.hexA)")
            .replacingOccurrences(of: "§hex", with: "\(sColor.hex)")
        
        print("Copied: \(colorFormatted)")
        
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(colorFormatted, forType: .string)
    }
}

// MARK: OPTIONS-VIEW
struct PaletteOptionsView: View {
    let optionsMargin = CGFloat(100)
    let optionsMinWidth = CGFloat(300)
    
    let maxViewCols = 999
    
    @Binding var showOptions: Bool
    @Binding var colCount: Int
    @Binding var cellSize: CGFloat
    @Binding var cellSpacing: CGFloat
    @Binding var cellRadius: CGFloat
    
    var body: some View {
        if (showOptions) {
            Spacer(minLength: 25)
            SectionView("View options") {
                HStack {
                    Text("Size").frame(width: optionsMargin, alignment: .leading)
                    TextField("Size", value: $cellSize, formatter: NumberFormatter())
                        .onReceive([self.cellSize].publisher.first()) { (value) in
                            SetVal(value: value, key: Manager.k_view_grid_cell_size)
                        }
                }
                HStack {
                    Text("Spacing").frame(width: optionsMargin, alignment: .leading)
                    TextField("Spacing", value: $cellSpacing, formatter: NumberFormatter())
                        .onReceive([self.cellSpacing].publisher.first()) { (value) in
                            SetVal(value: value, key: Manager.k_view_grid_cell_spacing)
                        }
                }
                HStack {
                    Text("Column count").frame(width: optionsMargin, alignment: .leading)
                    Stepper("\(colCount)", value: $colCount, in: 1...maxViewCols, onEditingChanged: {_ in
                        SetVal(value: colCount, key: Manager.k_view_grid_colCount)
                    }).frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    Text("Radius").frame(width: optionsMargin, alignment: .leading)
                    TextField("Radius", value: $cellRadius, formatter: NumberFormatter())
                        .onReceive([self.cellRadius].publisher.first()) { (value) in
                            SetVal(value: value, key: Manager.k_view_grid_cell_radius)
                        }.frame(maxWidth: 25)
                    Slider(value: $cellRadius, in: 0...50)
                        .onReceive([self.cellRadius].publisher.first()) { (value) in
                            SetVal(value: value, key: Manager.k_view_grid_cell_radius)
                        }
                }
            }.frame(minWidth: optionsMinWidth, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
    
    func SetVal(value: CGFloat, key: String) {
        UserDefaults.standard.setValue(Float(value), forKey: key)
    }
    func SetVal(value: Int, key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
}
