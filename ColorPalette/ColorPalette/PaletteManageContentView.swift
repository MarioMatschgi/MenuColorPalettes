//
//  EditContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import SwiftUI
import Combine

struct PaletteManageContentView: View {
    var palette: Palette
    
    @State private var showingAlert = false
    
    
    @State private var newNameText: String = ""
    var body: some View {
        VStack {
            Text("Editing: \(palette.palName)")
            Spacer(minLength: 20)
            PalettePreviewContentView(palette: palette, previewSize: 100).cornerRadius(25)
            
            Spacer(minLength: 20)
            
            VStack {
                Text("Rename:").frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    TextField("Enter new name", text: $newNameText)
                    Button(action: { }) {
                        Text("Rename")
                    }
                }
            }
            
            Spacer(minLength: 20)
            
            VStack {
                Text("Delete:").frame(maxWidth: .infinity, alignment: .leading)
                Button(action: { }) {
                    HStack {
                        Spacer()
                        Text("Delete").frame(maxWidth: .infinity)
                        Spacer()
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
            }
            
        }.padding().fixedSize().alert(isPresented: $showingAlert, content: {
            Alert(
              title: Text("Delete \"\(palette.palName)\"?"),
              message: Text("Do you want to delete \"\(palette.palName)\"?"),
                primaryButton: .destructive(Text("Delete"), action: { Manager.RemovePalette(name: palette.palName) }),
              secondaryButton: .cancel(Text("Cancel"), action: {})
            )
        })
    }
}


struct PaletteManageContentView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManageContentView(palette: Manager.GetPaletteByIndex(idx: 0))
    }
}
