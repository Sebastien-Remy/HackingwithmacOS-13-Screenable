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
        DocumentGroup(newDocument: ScreenableDocument()) { file in
            ContentView(document: file.$document)
        }
        .commands {
            CommandGroup(after: .saveItem) {
                Button("Export…") {
                    NSApp.sendAction(#selector(AppCommands.export),
                                     to: nil,
                                     from: nil
                    )
                }
                .keyboardShortcut("e")
            }
        }
    }
}

