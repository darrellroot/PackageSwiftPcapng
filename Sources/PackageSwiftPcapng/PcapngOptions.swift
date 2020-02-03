//
//  File.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation

public struct PcapngOptions {
    public static func makeOptions(data: Data, type: <T>) -> [<T>] {
        var options: [T] = []
        var data = data
        while true {
            guard data.count >= 4 else {
                return options
            }
            let code = Int(Pcapng.getUInt16(data: data))
            let length = Int(Pcapng.getUInt16(data: data.advanced(by: 2)))
            print("code \(code) length \(length) startIndex \(data.startIndex)")
            let value = data[data.startIndex + 4 ..< data.startIndex + 4 + length]
            if let option = T(code: code, length: length, value: value) {
                options.append(option)
                if case .endofopt = option {
                    return options
                }
            }
            let padding: Int
            switch length % 4 {  //option field padded to 32 bits
            case 0:
                padding = 0
            case 1:
                padding = 3
            case 2:
                padding = 2
            case 3:
                padding = 1
            default: // should never get here
                padding = 0
            }
            data = data.advanced(by: length + 4 + padding)
        }
    }
}
