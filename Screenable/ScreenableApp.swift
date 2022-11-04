//
//  ScreenableApp.swift
//  Screenable
//
//  Created by Sebastien REMY on 02/11/2022.
//

import SwiftUI

@main
struct ScreenableApp: App {
    var body: some Scene {
        if #available(macOS 13, *) {
            return DocumentGroup(newDocument: ScreenableDocument()) { file in
                ContentView(document: file.$document)
            }
            // CRASH .windowResizability(.contentSize) //only for macOS 13
        } else {
            return DocumentGroup(newDocument: ScreenableDocument()) { file in
                ContentView(document: file.$document)
            }
        }
    }
}

