//
//  MenuContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import SwiftUI
import Foundation

struct MenuContentView: View {
    @State var paletteName = ""
    @State var paletteCode = ""
    
    let accentColor = Color(red: 52/255, green: 152/255, blue: 219/255)
    
    let panelPadding = CGFloat(10)
    let panelMargin = CGFloat(10)
    let panelRadius = CGFloat(25)
    
    var body: some View {
        VStack {
            VStack {
                Text("Settings")
                Button("CLICK", action: {})
                Button("CLICK", action: {})
                Button("CLICK", action: {})
                Button("CLICK", action: {})
            }.padding(panelPadding).frame(maxWidth: .infinity, maxHeight: .infinity).background(RoundedRectangle(cornerRadius: panelRadius).fill(accentColor)).padding(panelMargin)
            VStack {
                Text("Color palettes")
            }.padding(panelPadding).frame(maxWidth: .infinity, maxHeight: .infinity).background(RoundedRectangle(cornerRadius: panelRadius).fill(accentColor)).padding(panelMargin)
            VStack {
                Text("MenuColorPalettes © 2020 Mario Elsnig & Peter Elsnig")
                Text("Default color palettes from flatuicolors.com")
            }.padding(panelPadding).frame(maxWidth: .infinity, maxHeight: .infinity).background(RoundedRectangle(cornerRadius: panelRadius).fill(accentColor)).padding(panelMargin)
        }.padding(panelMargin)
    }
}

struct MenuContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuContentView()
    }
}
