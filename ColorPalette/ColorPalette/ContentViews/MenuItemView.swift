//
//  MenueBarView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.11.20.
//

import SwiftUI

struct MenuItemView: View {
    let optionsMargin = CGFloat(80)
    
    @State var cellSize = CGFloat(UserDefaults.standard.float(forKey: Manager.k_viewCellSize))
    @State var cellSpacing = CGFloat(UserDefaults.standard.float(forKey: Manager.k_viewCellSpacing))
    @State var cellRadius = CGFloat(UserDefaults.standard.float(forKey: Manager.k_viewCellRadius))
    
    var body: some View {
        VStack {
            TitleView()
            
            SectionView("Palettes") {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: 4), spacing: cellSpacing) {
                    ForEach(0..<10) { idx in
                        VStack {
                            
                        }.frame(width: cellSize, height: cellSize, alignment: .center).background(Color.red).cornerRadius(cellSize / 100 * cellRadius)
                    }
                }
            }
            
            SectionView("View options") {
                HStack {
                    Text("Size").frame(width: optionsMargin, alignment: .leading)
                    TextField("Size", value: $cellSize, formatter: NumberFormatter())
                        .onReceive([self.cellSize].publisher.first()) { (value) in
                            SetVal(value: value, key: Manager.k_viewCellSize)
                        }
                }
                HStack {
                    Text("Spacing").frame(width: optionsMargin, alignment: .leading)
                    TextField("Spacing", value: $cellSpacing, formatter: NumberFormatter())
                        .onReceive([self.cellSpacing].publisher.first()) { (value) in
                            SetVal(value: value, key: Manager.k_viewCellSpacing)
                        }
                }
                HStack {
                    Text("Radius").frame(width: optionsMargin, alignment: .leading)
                    TextField("Radius", value: $cellRadius, formatter: NumberFormatter())
                        .onReceive([self.cellRadius].publisher.first()) { (value) in
                            SetVal(value: value, key: Manager.k_viewCellRadius)
                        }.frame(maxWidth: 25)
                    Slider(value: $cellRadius, in: 0...50)
                        .onReceive([self.cellRadius].publisher.first()) { (value) in
                            SetVal(value: value, key: Manager.k_viewCellRadius)
                        }
                }
            }
            
            SectionView {
                HStack {
                    Button("Preferences") { Manager.OpenPreferences() }
                    Button("Quit") { exit(0) }
                }
            }
        }.padding().fixedSize()
    }
    
    func SetVal(value: CGFloat, key: String) {
        UserDefaults.standard.setValue(Float(value), forKey: key)
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView()
    }
}
