//
//  PalettePreviewView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 22.11.20.
//

import SwiftUI

struct PalettePreviewView: View {
    @Binding var palette: Palette
    @State var cellSize: CGFloat
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: (CGFloat(100) / CGFloat(ceil(CGFloat(palette.palColors.count).squareRoot()))) - 1), spacing: 0, alignment: .leading), count: 1), alignment: .leading, spacing: 0, content: {
                ForEach(0..<palette.palColors.count) { idx in
                    Rectangle().fill(palette.palColors[idx].colColor.color).aspectRatio(1, contentMode: .fit)
                }
            }).frame(width: cellSize, height: cellSize)
        }.fixedSize()
    }
}
