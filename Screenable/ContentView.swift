//
//  ContentView.swift
//  Screenable
//
//  Created by Sebastien REMY on 02/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var document: ScreenableDocument
    
    let fonts = Bundle.main.loadStringArray(from: "Fonts.txt")
    let backgrounds = Bundle.main.loadStringArray(from: "Backgrounds.txt")
    
    var body: some View {
        HStack(spacing: 20) {
            if #available(macOS 13.0, *) {
                RenderView(document: document)
                // masOS 13 and above
                    .dropDestination(for: URL.self) {items, location in
                        handleDrop(of: items)
                    }
            } else {
                RenderView(document: document)
                // Under macOS 13
                // Source: https://swiftwithmajid.com/2020/04/01/drag-and-drop-in-swiftui/
                    .onDrop(of: ["public.url"],
                            delegate: UserImageDropDelegate(userImage: $document.userImage))
                
            }
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Caption: ")
                        .bold()
                    TextEditor(text: $document.caption)
                        .font(.title)
                        .border(.tertiary, width: 1)
                    
                    Picker("Select caption font", selection: $document.font) {
                        ForEach(fonts, id:\.self, content: Text.init)
                    }
                    Picker("Size of caption font", selection: $document.fontSize) {
                        ForEach(Array(stride(from: 12, through: 72, by: 4)), id:\.self) { size in
                            Text("\(size)pt")
                        }
                    }
                    
                    ColorPicker("Caption color:", selection: $document.captionColor)
                    
                }
                .labelsHidden() // Remove picker label but works fin with accessibility !
               
                VStack(alignment: .leading) {
                    Text("Background image")
                        .bold()
                    Picker("Background image", selection: $document.backgroundImage) {
                        Text("No background image")
                            .tag("")
                        Divider()
                        ForEach(backgrounds, id:\.self, content: Text.init)
                    }
                }
                .labelsHidden()
                VStack(alignment: .leading) {
                    Text("Background color")
                        .bold()
                    
                    Text("If set to non transparent, this will be drawn over backgroundcolor image.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 20) {
                        ColorPicker("Start:", selection: $document.backgroundColorTop)
                        ColorPicker("End:", selection: $document.backgroundColorBottom)
                    }
                }
            }
            .frame(width: 250)
        }
        .padding()
    }
    
    func handleDrop(of urls: [URL]) -> Bool {
        guard let url = urls.first else { return false }
        let loadedImage = try? Data(contentsOf: url)
        document.userImage = loadedImage
        return true
    }
}

// Drop Before macOS 13
// Source: https://swiftwithmajid.com/2020/04/01/drag-and-drop-in-swiftui/

struct UserImageDropDelegate: DropDelegate {
    @Binding var userImage: Data?
    func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: ["public.url"]) else {
            return false
        }
        
        guard let item = info.itemProviders(for: ["public.url"]).first  else { return false }
        
        _ = item.loadObject(ofClass: URL.self) { url, _ in
            if let url = url {
                DispatchQueue.main.async {
                    
                    let loadedImage = try? Data(contentsOf: url)
                    
                    userImage = loadedImage
                }
            }
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(ScreenableDocument()))
    }
}
