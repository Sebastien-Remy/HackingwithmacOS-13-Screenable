//
//  ContentView.swift
//  Screenable
//
//  Created by Sebastien REMY on 02/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var document: ScreenableDocument
    
    var body: some View {
        HStack(spacing: 20) {
            RenderView(document: document)
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Caption: ")
                        .bold()
                    TextEditor(text: $document.caption)
                        .font(.title)
                        .border(.tertiary, width: 1)
                }
            }
            .frame(width: 250)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(ScreenableDocument()))
    }
}
