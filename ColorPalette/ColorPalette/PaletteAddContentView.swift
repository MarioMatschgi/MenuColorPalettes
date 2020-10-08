//
//  PaletteAddContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 08.10.20.
//

import SwiftUI
import Combine

struct PaletteAddContentView: View {
    @State private var nameText: String = ""
    @State private var htmlText: String = ""
    
    var body: some View {
        VStack {
            Text("Add new palette")
            
            VStack {
                TextField("Palette name", text: $nameText)
                TextField("FlatUIColors code", text: $htmlText)
            }.frame(width: 200)
            
            Button(action: {
                Manager.AddPalette(palette: Manager.GeneratePaletteByHTML(name: nameText, html: htmlText))
                Manager.window?.close()
            }) {
                Text("Add palette")
            }
        }.padding().fixedSize()
    }
}


struct PaletteAddContentView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteAddContentView()
    }
}
