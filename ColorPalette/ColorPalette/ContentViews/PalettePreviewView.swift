//
//  PalettePreviewContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 08.10.20.
//

import SwiftUI
import Combine

// MARK: PALETTE-PREVIEW-VIEW
/// PalettePreviewView: The View for previewing a Palette
struct PalettePreviewView: View {
    var palette: Palette
    var colorFormat: String {
        return formats[selection]
    }
    
    // Grid stuff
    @State var colCount: Int = 0
    var palCountPublisher = PassthroughSubject<Int, Never>()
    let cellSize: CGVector
    let paletteColumns = 5
    let aColor = Color(red: 0/255, green: 152/255, blue: 0/255)
    func GetForBounds(row: Int) -> Int {
        return min(colCount-(row * paletteColumns), paletteColumns)
    }
    
    @State private var selection: Int = 0
    init(palette: Palette, previewSize: CGFloat) {
        self.palette = palette
        if self.palette.palColors.count == 0 {
            self.cellSize = CGVector(dx: previewSize, dy: previewSize)
        } else {
            self.cellSize = CGVector(dx: previewSize / CGFloat(paletteColumns), dy: previewSize / CGFloat(min(palette.palColors.count/paletteColumns, paletteColumns)))
        }
    }
    
    @State private var formats = [
        "§r, §g, §b",
        "§r, §g, §b, $a",
        "§hex",
        "§#hex",
        "§hexA",
        "§#hexA",
    ]
    var body: some View {
        VStack {
            ForEach (0..<(colCount / paletteColumns) + 1, id: \.self) {
                row in
                HStack {
                    ForEach (0..<GetForBounds(row: row), id: \.self) {
                        col in
                        VStack {
                            
                        }.frame(width: cellSize.dx, height: cellSize.dy).background(GetCol(idx: row * paletteColumns + col))
                    }
                }
            }
        }.onAppear() { self.colCount = max(palette.palColors.count, 1) }
    }
    
    func GetCol(idx: Int) -> Color {
        if palette.palColors[Manager.GetColorNameByIndex(idx: idx, palette: palette)] == nil {
            return Color.black
        }
        return palette.palColors[Manager.GetColorNameByIndex(idx: idx, palette: palette)]!.colColor.color
    }
}


struct PalettePreview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PalettePreviewView(palette: Manager.palettes[Manager.GetPaletteNameByIndex(idx: 0)]!, previewSize: 100)
        }
    }
}
