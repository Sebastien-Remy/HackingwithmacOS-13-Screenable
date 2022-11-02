//
//  Bundle-String-Array.swift
//  Screenable
//
//  Created by Sebastien REMY on 02/11/2022.
//

import Foundation

extension Bundle {
    func loadStringArray(from file: String) -> [String] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in Bundle.")
        }
        guard let string = try? String(contentsOf: url) else {
            fatalError("Failed to load \(file) fri Bundle.")
        }
        return string.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
    }
}
