//
//  EditContentView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 06.10.20.
//

import SwiftUI

struct EditContentView: View {
    @State var paletteName = ""
    @State var paletteCode = ""
    
    var body: some View {
        VStack {
            TextField("Enter palette name", text: $paletteName)
            TextField("Enter HTML code to convert", text: $paletteCode)
            Button("Convert", action: { GenerateArrayByHTML(name: paletteName, html: paletteCode) })
        }
    }
}


struct EditContentView_Previews: PreviewProvider {
    static var previews: some View {
        EditContentView()
    }
}



func GenerateArrayByHTML(name: String, html: String) {
    var dict = [String: ColorData]()
    
    // HTML to dict
    let htmlArr = html.components(separatedBy: "</div>")
    var idx = 0
    for element in htmlArr {
        let colorString = element.slice(from: "background-color: ", to: ";")?.replacingOccurrences(of: "rgb(", with: "").replacingOccurrences(of: ")", with: "")
        if colorString == nil {
            continue
        }
        let colors = colorString?.components(separatedBy: ", ")
        let color = SerializableColor(red: Double(colors![0])!, green: Double(colors![1])!, blue: Double(colors![2])!, alpha: 1)
        
        
        var nameString = element.slice(from: "<span", to: "/span>")
        nameString = nameString?.slice(from: ">", to: "<")
        dict[nameString!] = ColorData(color: color, idx: idx)
        
        idx += 1
    }
    
    Manager.AddPalette(name: name, dict: dict)
}
