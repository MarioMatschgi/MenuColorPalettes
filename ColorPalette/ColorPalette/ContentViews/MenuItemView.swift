//
//  MenueBarView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.11.20.
//

import SwiftUI

struct MenuItemView: View {
    let optionsMargin = CGFloat(80)
    let maxViewCols = 999
    let maxPreviewCols = 999
    
    @State var viewCellSize = CGFloat(UserDefaults.standard.float(forKey: Manager.k_viewCellSize))
    @State var viewCellSpacing = CGFloat(UserDefaults.standard.float(forKey: Manager.k_viewCellSpacing))
    @State var viewCellRadius = CGFloat(UserDefaults.standard.float(forKey: Manager.k_viewCellRadius))
    @State var viewColCount = UserDefaults.standard.integer(forKey: Manager.k_viewColCount)
    
    @State var previewColCount = UserDefaults.standard.integer(forKey: Manager.k_previewColCount)
    
    @State var showOptions = false
    
    @State var palettes = Manager.palettes
    
    var body: some View {
        VStack {
            TitleView()
            
            SectionView("Palettes") {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(viewCellSize), spacing: viewCellSpacing), count: viewColCount), spacing: viewCellSpacing) {
                    ForEach(0..<Manager.palettes.count, id: \.self) { idx in
                        PalettePreviewView(palette: $palettes[idx], colNum: $previewColCount, cellSize: $viewCellSize).cornerRadius(viewCellSize / 100 * viewCellRadius)
                    }
                }
            }
            
            if (showOptions) {
                SectionView("View options") {
                    HStack {
                        Text("Size").frame(width: optionsMargin, alignment: .leading)
                        TextField("Size", value: $viewCellSize, formatter: NumberFormatter())
                            .onReceive([self.viewCellSize].publisher.first()) { (value) in
                                SetVal(value: value, key: Manager.k_viewCellSize)
                            }
                    }
                    HStack {
                        Text("Spacing").frame(width: optionsMargin, alignment: .leading)
                        TextField("Spacing", value: $viewCellSpacing, formatter: NumberFormatter())
                            .onReceive([self.viewCellSpacing].publisher.first()) { (value) in
                                SetVal(value: value, key: Manager.k_viewCellSpacing)
                            }
                    }
                    HStack {
                        Text("Column count").frame(width: optionsMargin, alignment: .leading)
                        Stepper("\(viewColCount)", value: $viewColCount, in: 1...maxViewCols, onEditingChanged: {_ in
                            SetVal(value: viewColCount, key: Manager.k_viewColCount)
                        }).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack {
                        Text("Radius").frame(width: optionsMargin, alignment: .leading)
                        TextField("Radius", value: $viewCellRadius, formatter: NumberFormatter())
                            .onReceive([self.viewCellRadius].publisher.first()) { (value) in
                                SetVal(value: value, key: Manager.k_viewCellRadius)
                            }.frame(maxWidth: 25)
                        Slider(value: $viewCellRadius, in: 0...50)
                            .onReceive([self.viewCellRadius].publisher.first()) { (value) in
                                SetVal(value: value, key: Manager.k_viewCellRadius)
                            }
                    }
                }
                
                SectionView("Preview options") {
                    HStack {
                        Text("Column count").frame(width: optionsMargin, alignment: .leading)
                        Stepper("\(previewColCount)", value: $previewColCount, in: 1...maxPreviewCols, onEditingChanged: {_ in
                            SetVal(value: previewColCount, key: Manager.k_previewColCount)
                        }).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack {
                        Text("Radius").frame(width: optionsMargin, alignment: .leading)
                        TextField("Radius", value: $viewCellRadius, formatter: NumberFormatter())
                            .onReceive([self.viewCellRadius].publisher.first()) { (value) in
                                SetVal(value: value, key: Manager.k_viewCellRadius)
                            }.frame(maxWidth: 25)
                        Slider(value: $viewCellRadius, in: 0...50)
                            .onReceive([self.viewCellRadius].publisher.first()) { (value) in
                                SetVal(value: value, key: Manager.k_viewCellRadius)
                            }
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

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView()
    }
}
