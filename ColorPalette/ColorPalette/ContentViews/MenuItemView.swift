//
//  MenueBarView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.11.20.
//

import SwiftUI

struct MenuItemView: View {
    var body: some View {
        VStack {
            TitleView()
            
            SectionView("Palettes") {
                Text("GRID")
            }
            
            SectionView {
                HStack {
                    Button("Preferences") { Manager.OpenPreferences() }
                    Button("Quit") { exit(0) }
                }
            }
        }.padding().fixedSize()
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView()
    }
}
