//
//  PcapngShbOption.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation
import Network

public enum PcapngOption: CustomStringConvertible {
    
    // type = any
    case endofopt   // 0
    case comment(String) // 1
    //type = shb
    case hardware(String) // 2
    case os(String)  // 3
    case userappl(String)  // 4
    // type = ihb
    case name(String) //2
    case description(String) //3
    case ipv4Address(ip: IPv4Address, netmask: IPv4Address) //4
    case ipv6Address(ip: IPv6Address, prefix: Int) //5
    case macaddr(String) //6
    case euiaddr(String) //7
    

    static func getCString(length: Int, data: Data) -> String? {
        let cString = data[data.startIndex ..< data.startIndex + length]
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


    init?(code: Int, length: Int, data: Data, type: PcapngOptionType) {
        

        
        debugPrint("PcapngOption.init code \(code) length \(length) data \(data)")
        switch (type, code) {
        case (_ , 0):
            self = .endofopt
            return
        case (_ , 1):
            guard let string = PcapngOption.getCString(length: length, data: data) else {
                return nil
            }
            self = .comment(string)
            return
        case (.shb, 2):
            guard let string = PcapngOption.getCString(length: length, data: data) else {
                return nil
            }
            self = .hardware(string)
            return
        case (.shb, 3):
            guard let string = PcapngOption.getCString(length: length, data: data) else {
                return nil
            }
            self = .os(string)
            return
        case (.shb, 4):
            guard let string = PcapngOption.getCString(length: length, data: data) else {
                return nil
            }
            self = .userappl(string)
            return
        case (.idb, 2):
            guard let string = PcapngOption.getCString(length: length, data: data) else {
                return nil
            }
            self = .name(string)
            return
        case (.idb, 3):
            guard let string = PcapngOption.getCString(length: length, data: data) else {
                return nil
            }
            self = .description(string)
            return
        case (.idb, 4):
            guard data.count >= 8, let ipv4Address = IPv4Address(data[data.startIndex ..< data.startIndex + 4]), let netmask = IPv4Address(data[data.startIndex + 4 ..< data.startIndex + 8]) else {
                return nil
            }
            self = .ipv4Address(ip: ipv4Address,netmask: netmask)
            return
        case (.idb, 5):
            guard data.count >= 17, let ipv6Address = IPv6Address(data[data.startIndex ..< data.startIndex + 16]) else {
                return nil
            }
            let prefix = Int(data[data.startIndex + 16])
            self = .ipv6Address(ip: ipv6Address,prefix: prefix)
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
