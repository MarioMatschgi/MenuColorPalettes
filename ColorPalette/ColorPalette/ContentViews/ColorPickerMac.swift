//
//  ColorPickerMac.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 24.10.20.
//

import SwiftUI
import Combine

// MARK: COLOR-PICKER-MAC-VIEW
/// PaletteView: The View for viewing a Palette
struct ColorPickerMac: View {
    @Binding var color: SerializableColor //= SerializableColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    var body: some View {
        VStack {
            HStack {
                Text("Hex:").frame(minWidth: 50, alignment: .leading)
                Spacer()
                TextField("Enter hex color", text: $color.hexA).frame(minWidth: 100)
            }
            HStack {
                Text("RGBA:").frame(minWidth: 50, alignment: .leading)
                Spacer()
                TextField("Red", value: $color.red255, formatter: NumberFormatter()).frame(minWidth: 35)
                TextField("Green", value: $color.green255, formatter: NumberFormatter()).frame(minWidth: 35)
                TextField("Blue", value: $color.blue255, formatter: NumberFormatter()).frame(minWidth: 35)
                TextField("Alpha", value: $color.alpha255, formatter: NumberFormatter()).frame(minWidth: 35)
            }
        }.padding().fixedSize()
    }
}
