//
//  File.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation

public enum PcapngOption: CustomStringConvertible {
    
    case endofopt
    case comment(String)

    public var description: String {
        switch self {
        case .comment(let string):
            return "comment \(string)"
        case .endofopt:
            return "endofopt"
        }
    }
    init?(code: Int, length: Int, value: Data) {
        switch code {
            debugPrint("PcapngOption.init code \(code) length \(length) value \(value)")
        case 0:
            self = .endofopt
            return
        case 1:
            let cString = value[value.startIndex ..< value.startIndex + length]
            guard var commentString = String(data: cString, encoding: .utf8) else {
                debugPrint("PcapngOption unable to get string from \(cString)")
                return nil
            }
            if let nullIndex = commentString.firstIndex(of: "\0"){
                debugPrint("PcapngOption found null at index \(nullIndex)")
                commentString.removeSubrange(nullIndex ..< commentString.endIndex)
            }
            self = .comment(commentString)
            return
        default:
            debugPrint("unimplemented option code \(code)")
            return nil
        }
    }
}
