//
//  File.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation

public struct PcapngOptions {
    public static func makeOptions(data: Data) -> [PcapngOption] {
        var options: [PcapngOption] = []
        var data = data
        while true {
            guard data.count >= 4 else {
                return options
            }
            let code = Int(Pcapng.getUInt16(data: data))
            let length = Int(Pcapng.getUInt16(data: data.advanced(by: 2)))
            let value = data[data.startIndex + 4 ..< data.startIndex + 4 + length]
            if let option = PcapngOption(code: code, length: length, value: value) {
                options.append(option)
                if case .endofopt = option {
                    return options
                }
            }
            data = data.advanced(by: length + 4)
        }
    }
}
