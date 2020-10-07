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
    
    
    @State private var showingAlert = false
    @State var paletteToDelete = ""
    var body: some View {
        VStack {
            //
            Text("Color palettes (\(palCount))")
            Text("Click palette to delete it")
            
            VStack {
                ForEach (0..<(palCount / paletteColumns) + 1, id: \.self) {
                    row in
                    HStack {
                        ForEach (0..<GetForBounds(row: row), id: \.self) {
                            col in
                            VStack {
                                Button(action: { AskDeletePalette(paletteName: Manager.GetPaletteNameByIndex(idx: row * paletteColumns + col)) }) {
                                    VStack{ // ToDo: Replace with custom "Preview Stack"
                                        
                                    }.frame(width: cellSize, height: cellSize).background(RoundedRectangle(cornerRadius: panelRadius).fill(aColor)) // ToDo: Preview as view of background
                                }.buttonStyle(PlainButtonStyle()).frame(width: cellSize, height: cellSize).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                
                                Text("\(Manager.GetPaletteNameByIndex(idx: row * paletteColumns + col))")
                            }.padding(cellPadding)
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
    
    func AskDeletePalette(paletteName: String) {
        self.paletteToDelete = paletteName
        self.showingAlert = true
    }
}


struct EditContentView_Previews: PreviewProvider {
    static var previews: some View {
        EditContentView()
    }
}
