//
//  MenueBarView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.11.20.
//

import SwiftUI

struct MenuItemView: View {
    let optionsMargin = CGFloat(100)
    let maxViewCols = 999
    let maxCellCols = 999
    
    @State var gridCellSize = CGFloat(UserDefaults.standard.float(forKey: Manager.k_menu_grid_cell_size))
    @State var gridCellSpacing = CGFloat(UserDefaults.standard.float(forKey: Manager.k_menu_grid_cell_spacing))
    @State var gridCellRadius = CGFloat(UserDefaults.standard.float(forKey: Manager.k_menu_grid_cell_radius))
    @State var gridColCount = UserDefaults.standard.integer(forKey: Manager.k_menu_grid_colCount)
    
    @State var cellColCount = UserDefaults.standard.integer(forKey: Manager.k_menu_cell_colCount)
    
    @State var showOptions = false
    
    @State var modifyType: ModifyType = .None
    @State var modifyColorIdx: Int = -1
    @State var newPaletteName = "";
    
    @ObservedObject var palettesOO = PalettesOO()
    
    var body: some View {
        VStack {
            TitleView()
            
            SectionView("Palettes") {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(gridCellSize), spacing: gridCellSpacing), count: gridColCount), spacing: gridCellSpacing) {

                    ForEach(0..<palettesOO.palettes.count + 1, id: \.self) { idx in
                        if (idx >= palettesOO.palettes.count) {
                            Button(action: {
                                newPaletteName = "New palette"
                                modifyColorIdx = -1
                                
                                modifyType = .Add
                            }, label: {
                                if modifyType == .Add {
                                    MenuItemModifyView(newPaletteName: $newPaletteName, modifyType: $modifyType)
                                }
                                else {
                                    Image(systemName: "plus.square").font(.system(size: gridCellSize / 2)).frame(width: gridCellSize, height: gridCellSize)
                                }
                            }).buttonStyle(PlainButtonStyle())
//                            .popover(isPresented: self.$newPalettePopover, arrowEdge: .bottom) {
//                                VStack {
//                                    Text("Add a new palette")
//                                    TextField("Name", text: $newPaletteName)
//
//                                    HStack {
//                                        Button(action: { newPalettePopover = false }, label: { Text("Cancel") })
//                                        Spacer(minLength: 30)
//                                        Button(action: {
//                                            Manager.AddNewPalette(name: newPaletteName)
//                                            newPalettePopover = false
//                                        }, label: { Text("Add") })
//                                    }
//                                }.padding(20).fixedSize()
//                            }
                        }
                        else {
                            Safe(self.$palettesOO.palettes, index: idx) { binding in
                                
                                
                                
                                if modifyType == .Edit && modifyColorIdx == idx {
                                    MenuItemModifyView(newPaletteName: $newPaletteName, modifyType: $modifyType)//.frame(width: gridCellSize, height: gridCellSize)
                                }
                                else {
                                    Button(action: { Manager.ViewPalette(pal: $palettesOO.palettes[idx]) }, label: {
                                        PalettePreviewView(palette: binding, colNum: $cellColCount, cellSize: $gridCellSize).cornerRadius(gridCellSize / 100 * gridCellRadius).contextMenu(ContextMenu(menuItems: {
                                            Button(action: {
                                                newPaletteName = palettesOO.palettes[idx].palName
                                                modifyColorIdx = idx
                                                
                                                modifyType = .Edit
                                            }, label: { Text("Rename") })
                                            Button(action: { Manager.RemovePalette(name: palettesOO.palettes[idx].palName) }, label: { Text("Delete") })
                                        }))
                                    }).buttonStyle(PlainButtonStyle())
                                }
                                
                                
                            }
                        }
                    }
                }
            }
            
            if (showOptions) {
                Spacer(minLength: 25)
                SectionView("Grid options") {
                    HStack {
                        Text("Size").frame(width: optionsMargin, alignment: .leading)
                        TextField("Size", value: $gridCellSize, formatter: NumberFormatter())
                            .onReceive([self.gridCellSize].publisher.first()) { (value) in
                                SetVal(value: value, key: Manager.k_menu_grid_cell_size)
                            }
                    }
                    HStack {
                        Text("Spacing").frame(width: optionsMargin, alignment: .leading)
                        TextField("Spacing", value: $gridCellSpacing, formatter: NumberFormatter())
                            .onReceive([self.gridCellSpacing].publisher.first()) { (value) in
                                SetVal(value: value, key: Manager.k_menu_grid_cell_spacing)
                            }
                    }
                    HStack {
                        Text("Column count").frame(width: optionsMargin, alignment: .leading)
                        Stepper("\(gridColCount)", value: $gridColCount, in: 1...maxViewCols, onEditingChanged: {_ in
                            SetVal(value: gridColCount, key: Manager.k_menu_grid_colCount)
                        }).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack {
                        Text("Radius").frame(width: optionsMargin, alignment: .leading)
                        TextField("Radius", value: $gridCellRadius, formatter: NumberFormatter())
                            .onReceive([self.gridCellRadius].publisher.first()) { (value) in
                                SetVal(value: value, key: Manager.k_menu_grid_cell_radius)
                            }.frame(maxWidth: 25)
                        Slider(value: $gridCellRadius, in: 0...50)
                            .onReceive([self.gridCellRadius].publisher.first()) { (value) in
                                SetVal(value: value, key: Manager.k_menu_grid_cell_radius)
                            }
                    }
                }
                
                SectionView("Cell options") {
                    HStack {
                        Text("Column count").frame(width: optionsMargin, alignment: .leading)
                        Stepper("\(cellColCount)", value: $cellColCount, in: 1...maxCellCols, onEditingChanged: {_ in
                            SetVal(value: cellColCount, key: Manager.k_menu_cell_colCount)
                        }).frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
            SectionView {
                HStack {
                    Button("\(showOptions ? "Hide" : "Show") options") { showOptions = !showOptions }
                    Button("Preferences") { Manager.OpenPreferences() }
                    Button("Quit") { exit(0) }
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

struct MenuItemModifyView: View {
    @Binding var newPaletteName: String
    
    @Binding var modifyType: ModifyType
    
    var body: some View {
        VStack {
            if modifyType != .None {
                VStack {
                    Spacer()
                    TextField("Name", text: $newPaletteName)

                    Spacer().frame(maxHeight: 25)
                    HStack {
                        Button(action: { modifyType = .None }, label: { Text("Cancel") })
                        Spacer()
                        Button(action: {
                            if modifyType == .Edit {
                                print("Changed pal: \(newPaletteName)")
                            }
                            else if modifyType == .Add {
                                print("Added pal: \(newPaletteName)")
                                
                                Manager.AddNewPalette(name: newPaletteName)
                            }
                            else {
                                print("ERROR: Invalid pal modifyType!")
                            }
                            
                            modifyType = .None
                        }, label: { Text("Ok") })
                    }
                }
            }
        }
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView()
    }
}
