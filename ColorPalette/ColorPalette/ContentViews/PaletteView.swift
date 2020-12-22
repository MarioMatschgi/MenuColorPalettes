//
//  PaletteView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.12.20.
//

import SwiftUI

struct PaletteView: View {
    let optionsMargin = CGFloat(100)
    let optionsMinWidth = CGFloat(300)
    let maxViewCols = 999
    
    @Binding var palette: Palette
    
    @State var colCount = UserDefaults.standard.integer(forKey: Manager.k_view_grid_colCount)
    @State var cellSize = CGFloat(UserDefaults.standard.float(forKey: Manager.k_view_grid_cell_size))
    @State var cellSpacing = CGFloat(UserDefaults.standard.float(forKey: Manager.k_view_grid_cell_spacing))
    @State var cellRadius = CGFloat(UserDefaults.standard.float(forKey: Manager.k_view_grid_cell_radius))
    
    @State var editColorPopover = false;
    @State var newColorPopover = false;
    @State var newColorName = ""
    @State var newColorColor = Color.white
    
    @State var showOptions = false
    
    @State var updater: Bool = false
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: colCount), spacing: cellSpacing) {
                ForEach(0..<palette.palColors.count + 1, id: \.self) { idx in
                    if (idx >= palette.palColors.count) {
                        Button(action: {
                            newColorPopover = true
                        }, label: {
                            Image(systemName: "plus.square").font(.system(size: cellSize / 2))
                        }).buttonStyle(PlainButtonStyle())
                        .popover(isPresented: self.$newColorPopover, arrowEdge: .bottom) {
                            VStack {
                                Text("Add a new color")
                                TextField("Name", text: $newColorName)
                                ColorPicker("Color", selection: $newColorColor)

                                HStack {
                                    Button(action: { newColorPopover = false }, label: { Text("Cancel") })
                                    Spacer(minLength: 30)
                                    Button(action: {
                                        palette.palColors.append(PaletteColor(colName: newColorName, colColor: SerializableColor(color: newColorColor)))
                                        Manager.SavePalette(palette: palette)
                                        newColorPopover = false
                                    }, label: { Text("Add") })
                                }
                            }.padding(20).fixedSize()
                        }
                    }
                    else {
                        Button(action: { }, label: {
                            VStack {
                                Rectangle().fill(palette.palColors[idx].colColor.colorNA).frame(width: cellSize, height: cellSize).cornerRadius(cellSize / 100 * cellRadius)
                                Text("\(palette.palColors[idx].colName) C \(palette.palColors.count)")
                            }.contextMenu(ContextMenu(menuItems: {
                                Button(action: {
                                    newColorName = palette.palColors[idx].colName
                                    newColorColor = palette.palColors[idx].colColor.color
                                    editColorPopover = true
                                }, label: { Text("Edit") })
                                Button(action: {
                                    palette.palColors.remove(at: idx)
                                    Manager.SavePalette(palette: palette)
                                    updater.toggle()
                                }, label: { Text("Delete") })
                            })).popover(isPresented: self.$editColorPopover, arrowEdge: .bottom) {
                                VStack {
                                    Text("Edit color")
                                    TextField("Name", text: $newColorName)
                                    ColorPicker("Color", selection: $newColorColor)

                                    HStack {
                                        Button(action: { editColorPopover = false }, label: { Text("Cancel") })
                                        Spacer(minLength: 30)
                                        Button(action: {
                                            palette.palColors.append(PaletteColor(colName: newColorName, colColor: SerializableColor(color: newColorColor)))
                                            Manager.SavePalette(palette: palette)
                                            editColorPopover = false
                                        }, label: { Text("Ok") })
                                    }
                                }.padding(20).fixedSize()
                            }
                        }).buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
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
            
            SectionView {
                HStack {
                    Button("\(showOptions ? "Hide" : "Show") options") { showOptions = !showOptions }
                }
            }
        }.padding().fixedSize()
    }
    
    func SetVal(value: CGFloat, key: String) {
        UserDefaults.standard.setValue(Float(value), forKey: key)
    }
    func SetVal(value: Int, key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
}
