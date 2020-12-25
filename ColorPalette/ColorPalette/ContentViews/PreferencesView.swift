//
//  PreferencesView.swift
//  ColorPalette
//
//  Created by Mario Elsnig on 21.11.20.
//

import SwiftUI

struct PreferencesView: View {
    let sectionMargin = CGFloat(30)
    
    @State private var isAutoStart = true
    @State private var hideDockIcon = UserDefaults.standard.bool(forKey: Manager.k_hideDockIcon)
    
    
    var body: some View {
        VStack {
            TitleView()
            SectionView("Options") {
                VStack {
                    Toggle(isOn: $isAutoStart, label: {
                        Text("Start at login")
                    }).frame(maxWidth: .infinity, alignment: .leading)
                    .onAppear() {
                        // ToDo: Load isAutoStart
                    }
                    Toggle(isOn: $hideDockIcon, label: {
                        Text("hide app in dock")
                    }).frame(maxWidth: .infinity, alignment: .leading)
                    .onReceive([self.hideDockIcon].publisher.first()) { (value) in
                        UserDefaults.standard.setValue(value, forKey: Manager.k_hideDockIcon)
                    }
                    HStack {
                        Button("Open palettes folder") { ShowInFinder(url: assetFilesDirectory(name: "Palettes", shouldCreate: true)) }
                        Spacer().frame(width: 20)
                        Button("Reload palettes") { Manager.LoadAllPalettes() }
                        Spacer().frame(width: 20)
                        Button("Add default palettes") {
                            Manager.AddDefaultPalettes()
                            Manager.LoadAllPalettes()
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, sectionMargin)
            }
            Spacer(minLength: 30)
            
            SectionView {
                Text("Hints:")
                Text("Command click on a color to copy it without switching focus to MenueColorPalettes")
                Text("Rightclick on a color or palette to edit or delete it")
                Text("To import colors from flatuicolors.com go to their palette, get the sourcecode and copy\nthe div with the class \"colors\"")
                HStack {
                    Link(destination: URL(string: Manager.PROJECT_PAGE)!, label: {
                        Text("Project page")
                    })
                    Spacer().frame(width: 20)
                    Link(destination: URL(string: Manager.TUTORIAL_PAGE)!, label: {
                        Text("Tutorial")
                    })
                    Spacer().frame(width: 20)
                    Link(destination: URL(string: Manager.GITHUB_PAGE)!, label: {
                        Text("GitHub page")
                    })
                }
            }
            Spacer(minLength: 30)
            SectionView {
                Text("Default color palettes from flatuicolors.com")
                Spacer(minLength: 10)
                Text("MenuColorPalettes \(Manager.VERSION) © \(Manager.COPYRIGHT_DATE) Mario Elsnig")
            }
        }.fixedSize().padding()
    }
}

class PreferencesWindow: NSWindow {
    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 0, height: 0), styleMask: [.closable, .titled, .hudWindow], backing: .buffered, defer: false)
        
        contentView = NSHostingView(rootView: PreferencesView())

        isReleasedWhenClosed = false
        center()
        title = "Preferences"
        setFrameAutosaveName(title)
        makeKeyAndOrderFront(nil)
        level = .floating
        canHide = false

        // Show dock icon if hidden
        Manager.SetDockVisibility(visible: true)
        
        makeKey()
    }
    
    override func close() {
        super.close()
        
        // Hide dock icon if shoud be hidden
        Manager.SetDockVisibility(visible: !UserDefaults.standard.bool(forKey: Manager.k_hideDockIcon))
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
