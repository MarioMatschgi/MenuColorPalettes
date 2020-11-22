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
//            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: CGFloat(100) / CGFloat(10).squareRoot()), spacing: 0), count: 1), alignment: .center, spacing: 0, content: {
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: CGFloat(100) / CGFloat(round(CGFloat(palette.palColors.count).squareRoot()))), spacing: 0), count: 1), alignment: .center, spacing: 0, content: {
                ForEach(0..<palette.palColors.count) { idx in
                    Rectangle().fill(palette.palColors[idx].colColor.color).aspectRatio(1, contentMode: .fit)
                }
//                ForEach(0..<10) { idx in
//                    Rectangle().fill(Color.red).aspectRatio(1, contentMode: .fit)
//                }
            }).frame(width: cellSize, height: cellSize)
        }.fixedSize()
    }
}
