//
//  PalettePreviewView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 22.11.20.
//

import SwiftUI

struct PalettePreviewView: View {
    @Binding var palette: Palette
    @Binding var colNum: Int
    @Binding var cellSize: CGFloat
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 0, alignment: .center), count: colNum), alignment: .center, spacing: 0, content: {
                ForEach(0..<palette.palColors.count, id: \.self) { idx in
                    Rectangle().fill(palette.palColors[idx].colColor.color).aspectRatio(1, contentMode: .fit)
                }
            })
        }.frame(width: cellSize, height: cellSize)
    }
}
