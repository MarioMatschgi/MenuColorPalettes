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
    
    // Grid stuff
    @State var colCount: Int = 20
    var palCountPublisher = PassthroughSubject<Int, Never>()
    let panelPadding = CGFloat(10)
    let panelMargin = CGFloat(10)
    let panelRadius = CGFloat(25)
    let cellSize = CGFloat(100)
    let cellPadding = CGFloat(10)
    let paletteColumns = 5
    let aColor = Color(red: 0/255, green: 152/255, blue: 0/255)
    func GetForBounds(row: Int) -> Int {
        return min(colCount-(row * paletteColumns), paletteColumns)
    }
    
    init(palette: Palette) {
        self.palette = palette
        self.colCount = palette.palColors.count
    }
    
    var body: some View {
        VStack {
            //
            Text("Color palette \(palette.palName)")
            Text("\(palette.palColors.count)")
            Spacer()
            
            VStack {
                ForEach (0..<(colCount / paletteColumns) + 1, id: \.self) {
                    row in
                    HStack {
                        ForEach (0..<GetForBounds(row: row), id: \.self) {
                            col in
                            VStack {
                                Button(action: {  }) {
                                    VStack{ // ToDo: Replace with custom "Preview Stack"
                                        
                                    }.frame(width: cellSize, height: cellSize).background(RoundedRectangle(cornerRadius: panelRadius).fill(GetCol(idx: row * paletteColumns + col)))
                                }.buttonStyle(PlainButtonStyle()).frame(width: cellSize, height: cellSize).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                
                                Text("\(Manager.GetColorNameByIndex(idx: row * paletteColumns + col, palette: palette))")
                            }.padding(cellPadding)
                        }
                    }
                }
            }
        }.frame(minWidth: 300, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity).padding(20)
    }
    
    func GetCol(idx: Int) -> Color {
        return palette.palColors[Manager.GetColorNameByIndex(idx: idx, palette: palette)]!.colColor.color
    }
}


struct PaletteContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PaletteContentView(palette: Manager.palettes[Manager.GetPaletteNameByIndex(idx: 0)]!)
        }
    }
}
