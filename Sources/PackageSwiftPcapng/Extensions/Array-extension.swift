//
//  File.swift
//  
//
//  Created by Darrell Root on 2/6/20.
//

import Foundation
extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
