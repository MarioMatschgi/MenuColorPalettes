//
//  EditContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import SwiftUI
import Combine

struct EditContentView: View {
    static var instance: EditContentView? = nil
    
    @State var paletteName = ""
    @State var paletteCode = ""
    
    @State var popover: NSPopover!
    
    // Grid stuff
    @State var palCount = Manager.palettes.count
    var palCountPublisher = PassthroughSubject<Int, Never>()
    let panelPadding = CGFloat(10)
    let panelMargin = CGFloat(10)
    let panelRadius = CGFloat(25)
    let cellSize = CGFloat(100)
    let cellPadding = CGFloat(10)
    let paletteColumns = 4
    let aColor = Color(red: 0/255, green: 152/255, blue: 0/255)
    func GetForBounds(row: Int) -> Int {
        return min(palCount-(row * paletteColumns), paletteColumns)
    }
    
    
    init() {
        EditContentView.instance = self;
    }
    
    
    @State private var selection: Int = 0
    
    @State private var showingAlert = false
    @State var paletteToDelete = ""
    
    
    @State private var nameText: String = ""
    var body: some View {
        VStack {
            //
            Text("Color palettes (\(palCount))")
            
            VStack {
                ForEach (0..<(palCount / paletteColumns) + 1, id: \.self) {
                    row in
                    HStack {
                        ForEach (0..<GetForBounds(row: row), id: \.self) {
                            col in
                            
                            Group {
                                let palette = Manager.palettes[Manager.GetPaletteNameByIndex(idx: row * paletteColumns + col)]
                                ZStack {
                                    VStack {
                                        PalettePreviewContentView(palette: palette!, previewSize: cellSize).frame(width: cellSize, height: cellSize).cornerRadius(panelRadius).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                        
//                                        Text("\(Manager.GetPaletteNameByIndex(idx: row * paletteColumns + col))")
                                        TextField("\(palette!.palName)", text: $nameText, onCommit: {
                                            print("NAME ÄNDERN \($nameText)")
                                        })
                                    }.padding(cellPadding)
                                    
                                    VStack(alignment: .leading) {
                                        Button(action: { }) {
                                            Text("X").foregroundColor(Color.red)
                                        }.buttonStyle(PlainButtonStyle()).frame(width: 20, height: 20).background(Color.white).cornerRadius(panelRadius).overlay(
                                            RoundedRectangle(cornerRadius: panelRadius)
                                                .stroke(Color.black, lineWidth: 2)
                                        )
                                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
                                }.frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
            }.alert(isPresented: $showingAlert, content: {
                Alert(
                  title: Text("Delete \"\(paletteToDelete)\"?"),
                  message: Text("Do you want to delete \"\(paletteToDelete)\"?"),
                    primaryButton: .destructive(Text("Delete"), action: { Manager.RemovePalette(name: paletteToDelete) }),
                  secondaryButton: .cancel(Text("Cancel"), action: {})
                )
            })
            
            // Add Panel
            VStack {
                Text("Please enter the name of the palette and the HTML code")
                TextField("Enter palette name", text: $paletteName)
                TextField("Enter HTML code to convert", text: $paletteCode)
                Button("Convert", action: { Manager.AddPalette(palette: Manager.GeneratePaletteByHTML(name: paletteName, html: paletteCode)) })
            }.padding(20)
        }
        .onReceive(palCountPublisher, perform: {
            newPalCount in
            self.palCount = newPalCount
        })
    }
}


struct EditContentView_Previews: PreviewProvider {
    static var previews: some View {
        EditContentView()
    }
}
