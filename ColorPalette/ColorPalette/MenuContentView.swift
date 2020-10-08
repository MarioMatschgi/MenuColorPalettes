//
//  MenuContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import SwiftUI
import Combine
import Foundation

struct MenuContentView: View {
    static var instance: MenuContentView? = nil
    
    
    @State var paletteName = ""
    @State var paletteCode = ""
    
    
    let accentColor = Color(red: 52/255, green: 152/255, blue: 219/255)
    
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
        MenuContentView.instance = self;
    }
    
    @State private var showingAlert = false
    @State private var paletteToDelete: Palette?
    
    var body: some View {
        VStack {
            VStack {
                Text("Color palettes (\(palCount))")
                
                // Grid
                VStack {
                    ForEach (0..<(palCount / paletteColumns) + 1, id: \.self) {
                        row in
                        HStack {
                            ForEach (0..<GetForBounds(row: row), id: \.self) {
                                col in
                                Group {
                                    let palette = Manager.palettes[Manager.GetPaletteNameByIndex(idx: row * paletteColumns + col)]
                                    VStack {
                                        Button(action: {
                                            Manager.OpenWindow(type: .PaletteViewWindow, palette: palette)
                                        }, label: {
                                            VStack {
                                                PalettePreviewContentView(palette: palette!, previewSize: cellSize)
                                            }.frame(width: cellSize, height: cellSize).cornerRadius(panelRadius)
                                        }).buttonStyle(PlainButtonStyle()).frame(width: cellSize, height: cellSize).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                        Text("\(palette!.palName)")
                                    }.padding(cellPadding).contextMenu(ContextMenu(menuItems: {
                                        Button(action: {
                                            Manager.OpenWindow(type: .PaletteEditWindow, palette: palette)
                                        }) {
                                            Text("Edit")
                                        }
                                        Button(action: {
                                            Manager.OpenWindow(type: .PaletteViewWindow, palette: palette)
                                        }) {
                                            Text("View")
                                        }
                                        Button(action: {
                                            self.showingAlert = true
                                            paletteToDelete = palette
                                        }) {
                                            Text("Delete")
                                        }
                                    }))
                                }
                            }
                            VStack {
                                Button(action: {
                                    Manager.OpenWindow(type: .PaletteAddWindow)
                                }, label: {
                                    VStack {
                                        VStack {
                                            Image("Add").resizable()
                                        }.frame(width: cellSize / 100 * 75, height: cellSize / 100 * 75)
                                    }.frame(width: cellSize, height: cellSize).background(RoundedRectangle(cornerRadius: 25).fill(Color.accentColor))
                                }).buttonStyle(PlainButtonStyle()).frame(width: cellSize, height: cellSize).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                Text(" ")
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack {
                Text("Options")
                HStack {
                    Button("Open palettes folder", action: { ShowInFinder(url: assetFilesDirectory(name: "Palettes", shouldCreate: true)) })
                    Button("QUIT", action: { exit(0) })
                    Button("Reload palettes", action: { Manager.LoadPalettes() })
                }
            }
            
            VStack {
                Text("MenuColorPalettes © 2020 Mario Elsnig & Peter Elsnig")
                Text("Default color palettes from flatuicolors.com")
            }
        }.padding(panelPadding).frame(maxWidth: .infinity, maxHeight: .infinity).padding(panelMargin).fixedSize()
        .onReceive(palCountPublisher, perform: {
            newPalCount in
            self.palCount = newPalCount
        }).alert(isPresented: $showingAlert, content: {
            Alert(
              title: Text("Delete \"\(paletteToDelete!.palName)\"?"),
              message: Text("Do you want to delete \"\(paletteToDelete!.palName)\"?"), primaryButton: .destructive(Text("Delete"), action: {
                    Manager.RemovePalette(name: paletteToDelete!.palName)
                }), secondaryButton: .cancel(Text("Cancel"), action: { })
            )
        })
    }
}

struct MenuContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuContentView()
    }
}
