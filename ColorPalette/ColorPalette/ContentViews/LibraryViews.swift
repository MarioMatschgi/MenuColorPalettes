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
struct SectionView2C<Content: View, TitleContent: View>: View {
    let content: Content
    let titleContent: TitleContent?
    var title: String
    
    init(_ title: String = "", titleContent: () -> TitleContent, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.titleContent = titleContent()
        self.title = title
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title).font(.title).frame(maxWidth: .infinity, alignment: .leading)
                if titleContent != nil {
                    titleContent
                }
            }
            VStack {
                content
            }
        }
    }
}

struct TitleView: View {
    var body: some View {
        Text("Menu Color Palettes").font(.largeTitle)
        Spacer(minLength: 10)
    }
}

struct Safe<T: RandomAccessCollection & MutableCollection, C: View>: View {
    
    typealias BoundElement = Binding<T.Element>
    private let binding: BoundElement
    private let content: (BoundElement) -> C
    
    init(_ binding: Binding<T>, index: T.Index, @ViewBuilder content: @escaping (BoundElement) -> C) {
        self.content = content
        self.binding = .init(get: { binding.wrappedValue[index] },
                             set: { binding.wrappedValue[index] = $0 })
    }
    
    var body: some View {
        content(binding)
    }
}
