//
//  PcapngShbOption.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation

public enum PcapngOption: CustomStringConvertible {
    
    case endofopt   // 0
    case comment(String) // 1
    case hardware(String) // 2
    case os(String)  // 3
    case userappl(String)  // 4

    init?(code: Int, length: Int, value: Data) {
        
        func getCString(length: Int, value: Data) -> String? {
            let cString = value[value.startIndex ..< value.startIndex + length]
            guard var string = String(data: cString, encoding: .utf8) else {
                debugPrint("PcapngOption unable to get string from \(cString)")
                return nil
            }
            if let nullIndex = string.firstIndex(of: "\0"){
                debugPrint("PcapngOption found null at index \(nullIndex)")
                string.removeSubrange(nullIndex ..< string.endIndex)
            }
            return string
        }

        
        debugPrint("PcapngOption.init code \(code) length \(length) value \(value)")
        switch code {
        case 0:
            self = .endofopt
            return
        case 1:
            guard let string = getCString(length: length, value: value) else {
                return nil
            }
            self = .comment(string)
            return
        case 2:
            guard let string = getCString(length: length, value: value) else {
                return nil
            }
            self = .hardware(string)
            return
        case 3:
            guard let string = getCString(length: length, value: value) else {
                return nil
            }
            self = .os(string)
            return
        case 4:
            guard let string = getCString(length: length, value: value) else {
                return nil
            }
            self = .userappl(string)
            return
        default:
            debugPrint("unimplemented option code \(code)")
            return nil
        }
    }// init
    
    public var description: String {
        switch self {
        case .endofopt:
            return "endofopt"
        case .comment(let string):
            return "comment \(string)"
        case .hardware(let string):
            return "hardware \(string)"
        case .os(let string):
            return "os \(string)"
        case .userappl(let string):
            return "userappl \(string)"
        }
    }

}
