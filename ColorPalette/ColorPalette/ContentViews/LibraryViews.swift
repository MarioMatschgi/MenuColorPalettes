//
//  LibraryView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.11.20.
//

import SwiftUI

struct SectionView<Content: View>: View {
    let content: Content
    var title: String
    
    init(_ title: String = "", @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
    }
    
    var body: some View {
        VStack {
            Text(title).font(.title).frame(maxWidth: .infinity, alignment: .leading)
            content
        }
    }
}

struct TitleView: View {
    var body: some View {
        Text("Menu Color Palettes").font(.largeTitle)
        Spacer(minLength: 10)
    }
}
