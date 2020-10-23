//
//  PaletteAddContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 08.10.20.
//

import SwiftUI
import Combine

// MARK: ADD-PALETTE-VIEW
/// AddPaletteView: The View for adding a new Palette
struct AddPaletteView: View {
    @State private var nameText: String = "New Palette"
    @State private var htmlText: String = ""
    
    var body: some View {
        VStack {
            Text("Add new palette \"\(nameText)\"")
            Spacer(minLength: 20)
            
            VStack {
                Text("Enter Palette name*").frame(maxWidth: .infinity, alignment: .leading)
                TextField("Palette name", text: $nameText)
                Spacer(minLength: 15)
                
                Text("Enter FlatUIColors div \"colors\"").frame(maxWidth: .infinity, alignment: .leading)
                TextField("FlatUIColors code", text: $htmlText)
                Spacer(minLength: 15)
                
                Text("Fields with \"*\" are required").frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(width: 400)
            
            Button(action: {
                Manager.AddPalette(palette: Manager.GeneratePaletteByHTML(name: nameText, html: htmlText))
                Manager.window?.close()
//                AppDelegate.togglePopover(nil)
            }) { Text("Add palette") }
        }.padding().fixedSize()
    }
}


struct PaletteAddContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaletteView()
    }
}
