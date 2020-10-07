//
//  MenuContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import SwiftUI
import Foundation

struct MenuContentView: View {
    static var instance: MenuContentView? = nil
    
    @State var paletteName = ""
    @State var paletteCode = ""
    
    let accentColor = Color(red: 52/255, green: 152/255, blue: 219/255)
    let aColor = Color(red: 0/255, green: 152/255, blue: 0/255)
    
    let panelPadding = CGFloat(10)
    let panelMargin = CGFloat(10)
    let panelRadius = CGFloat(25)
    
    let paletteColumns = 4
    
    func GetForBounds(row: Int) -> Int {
        return min(Manager.palettes.count-(row * paletteColumns), paletteColumns)
    }
    init() { MenuContentView.instance = self }
    
    var body: some View {
        VStack {
            VStack {
                Text("Color palettes (\(Manager.palettes.count)")
                
                VStack {
                    ForEach (0..<(Manager.palettes.count / paletteColumns) + 1) {
                        row in
                        HStack {
                            ForEach (0..<GetForBounds(row: row)) {
                                col in
                                VStack {
                                    Button("Click", action: {}).buttonStyle(BorderlessButtonStyle()).frame(width: 100, height: 100).background(RoundedRectangle(cornerRadius: panelRadius).fill(aColor)) // ToDo: Preview as view of background
//                                    Text("R: \(row) C: \(col) RC: \(row * paletteColumns + col)")
                                    Text("A\(Manager.GetPaletteNameByIndex(idx: row * paletteColumns + col))")
                                }
                            }
                        }
                    }
                }
                
                Text("GRID WITH PALETES HERE")
            }
            
            
            
            HStack {
                Button("Manage palettes", action: { Manager.OpenWindow(type: .PaletteManagingWindow) })
            }
            
            Spacer()
            
            VStack {
                Text("Settings")
                Button("CLICK", action: {})
                Button("Reload palettes", action: { Manager.LoadPalettes() })
                Button("QUIT", action: { exit(0) })
            }
            
            // ToDo: Quit Button
            
            VStack {
                Text("MenuColorPalettes © 2020 Mario Elsnig & Peter Elsnig")
                Text("Default color palettes from flatuicolors.com")
            }
        }.padding(panelPadding).frame(maxWidth: .infinity, maxHeight: .infinity).background(RoundedRectangle(cornerRadius: panelRadius).fill(accentColor)).padding(panelMargin)
    }
}

struct MenuContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuContentView()
    }
}
