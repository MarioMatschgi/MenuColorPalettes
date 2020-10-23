//
//  PaletteViewOptionsContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 08.10.20.
//

import SwiftUI
import Combine

// MARK: PALETTE-VIEW-OPTIONS-VIEW
/// PaletteViewOptionsView: The View for the viewing options for a Palette
struct PaletteViewOptionsView: View {
    var palette: Palette
    
    @State private var palColCount = 0
    @State private var palCellSize = 0
    @State private var palCellRadius = Double(0)
    
    let labelWidth = CGFloat(200)
    let valueWidth = CGFloat(100)
    
    var body: some View {
        VStack {
            Text("Palette view options for palette: \(palette.palName)")
            
            VStack {
                HStack {
                    Text("Palette column amount: ").frame(width: labelWidth, alignment: .leading)
                    Spacer()
                    Text("\(palColCount)").frame(alignment: .trailing)
                    TextField("", value: $palColCount, formatter: NumberFormatter(), onCommit: {
                        UserDefaults.standard.setValue(palColCount, forKey: "\(palette.palName).palColCount")
                    }).frame(width: valueWidth).onAppear() {
                        self.palColCount = UserDefaults.standard.integer(forKey: "\(palette.palName).palColCount")
                    }
                }.frame(alignment: .leading)
                HStack {
                    Text("Palette cell size: ").frame(width: labelWidth, alignment: .leading)
                    Spacer()
                    Text("\(palCellSize)").frame(alignment: .trailing)
                    TextField("", value: $palCellSize, formatter: NumberFormatter(), onCommit: {
                        UserDefaults.standard.setValue(palCellSize, forKey: "\(palette.palName).palCellSize")
                    }).frame(width: valueWidth).onAppear() {
                        self.palCellSize = UserDefaults.standard.integer(forKey: "\(palette.palName).palCellSize")
                    }
                }.frame(alignment: .leading)
                HStack {
                    Text("Palette cell radius: ").frame(width: labelWidth, alignment: .leading)
                    Spacer()
                    Text("\(Int(palCellRadius))").frame(alignment: .trailing)
                    Slider(value: $palCellRadius, in: 0...50, onEditingChanged: {_ in
                        UserDefaults.standard.setValue(palCellRadius, forKey: "\(palette.palName).palCellRad")
                    }).frame(width: valueWidth).onAppear() {
                        self.palCellRadius = Double(UserDefaults.standard.integer(forKey: "\(palette.palName).palCellRad"))
                    }
                }.frame(alignment: .leading)
            }
        }.fixedSize().padding()
    }
}


struct PaletteViewOptionsContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PaletteViewOptionsView(palette: Manager.palettes[Manager.GetPaletteNameByIndex(idx: 0)]!)
        }
    }
}
