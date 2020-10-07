//
//  EditContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import SwiftUI

struct EditContentView: View {
    @State var paletteName = ""
    @State var paletteCode = ""
    
    var body: some View {
        VStack {
            Text("Please enter the name of the palette and the HTML code")
            TextField("Enter palette name", text: $paletteName)
            TextField("Enter HTML code to convert", text: $paletteCode)
            Button("Convert", action: { Manager.AddPalette(palette: Manager.GeneratePaletteByHTML(name: paletteName, html: paletteCode)) })
        }.padding(20)
    }
}


struct EditContentView_Previews: PreviewProvider {
    static var previews: some View {
        EditContentView()
    }
}
