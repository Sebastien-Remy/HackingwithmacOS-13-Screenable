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
        TextEditor(text: $document.caption)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(ScreenableDocument()))
    }
}
