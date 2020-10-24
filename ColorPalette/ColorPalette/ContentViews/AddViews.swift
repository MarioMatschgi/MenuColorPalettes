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
                HStack {
                    Text("Enter Palette name*")
                    TextField("Palette name", text: $nameText)
                }
                Spacer(minLength: 15)
                
                HStack {
                    Text("Enter FlatUIColors div \"colors\"")
                    TextField("FlatUIColors code", text: $htmlText)
                }
                Spacer(minLength: 15)
                
                Text("Fields with \"*\" are required").frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(width: 400)
            
            Button(action: {
                Manager.AddPalette(palette: Manager.GeneratePaletteByHTML(name: nameText, html: htmlText))
                Manager.window?.close()
                if let button = AppDelegate.statusBarItem.button {
                    AppDelegate.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                }
            }) { Text("Add palette") }
        }.padding().fixedSize()
    }
}

// MARK: ADD-COLOR-VIEW
/// AddPaletteView: The View for adding a new Palette
struct AddColorView: View {
    @Binding var palette: Palette
    @Binding var isAddingColor: Bool
    
    @State var nameText: String = "New Color"
    @State var color = SerializableColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    @State var colorPickerPopover = false
    
    var body: some View {
        VStack {
            Text("Add new color \"\(nameText)\"")
            Spacer(minLength: 20)
            
            VStack {
                HStack {
                    Text("Enter color name*")
                    TextField("Color name", text: $nameText)
                }
                Spacer(minLength: 15)
                
                HStack {
                    Text("Pick color*")
                    Spacer()
                    Button(action: { colorPickerPopover = true }) {
                        VStack { }.frame(maxWidth: .infinity, maxHeight: .infinity).background(color.color)
                    }.buttonStyle(PlainButtonStyle())
                    .popover(isPresented: $colorPickerPopover, arrowEdge: .top, content: {
                        ColorPickerMac(color: $color)
                    })
                }
                Spacer(minLength: 15)
                
                Text("Fields with \"*\" are required").frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(width: 400)
            
            HStack {
                Button(action: {
                    self.isAddingColor = false
                }) { Text("cancel") }
                Button(action: {
                    self.palette.palColors[nameText] = PaletteColor(colIdx: palette.palColors.count, colName: nameText, colColor: color)
                }) { Text("Add color to palette \(self.palette.palColors.count)") }
            }
        }.padding().fixedSize()
    }
}

struct PaletteAddContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaletteView()
    }
}
