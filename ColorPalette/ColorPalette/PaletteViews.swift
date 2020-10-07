//
//  PaletteViews.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 07.10.20.
//

import Combine
import SwiftUI

struct PaletteGridContentView: View {
    static var instances: [PaletteGridContentView]? = nil
    
    
    var action: () -> Void
    
//    var cellVStack: View
    let paletteColumns = 4
    let cellSize = CGFloat(100)
    let cellRadius = CGFloat(25)
    let cellPadding = CGFloat(10)
    
    
    
    let aColor = Color(red: 0/255, green: 152/255, blue: 0/255)
    
    
    
    @State var palCount = Manager.palettes.count
    var palCountPublisher = PassthroughSubject<Int, Never>()
    static func SendPalCountPublisher(val: Int) {
        if instances == nil {
            return
        }
        
        for instance in instances! {
            instance.palCountPublisher.send(val)
        }
    }
    
    
    var body: some View {
        VStack {
            ForEach (0..<(palCount / paletteColumns) + 1, id: \.self) {
                row in
                HStack {
                    ForEach (0..<GetForBounds(row: row), id: \.self) {
                        col in
                        VStack {
                            Button(action: action, label: {
                                VStack{ // ToDo: Replace with custom "Preview Stack"
                                    
                                }.frame(width: cellSize, height: cellSize).background(RoundedRectangle(cornerRadius: cellRadius).fill(aColor)) // ToDo: Preview as view of background
                            }).buttonStyle(PlainButtonStyle()).frame(width: cellSize, height: cellSize).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                            Text("\(Manager.GetPaletteNameByIndex(idx: row * paletteColumns + col))")
                        }.padding(cellPadding)
                    }
                }
            }
        }
    }
    
    func GetForBounds(row: Int) -> Int {
        return min(palCount-(row * paletteColumns), paletteColumns)
    }
}


struct PaletteGridContentView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteGridContentView(action: { })
    }
}
