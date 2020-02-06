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
    // type = epb
    case flags(UInt32) //2
    case hash(algorithm: UInt8, hash: Data)
    case dropcount(UInt64) // 8
    // type = isb
    case startTime(UInt64) //2
    case endTime(UInt64)  // 3
    case ifrecv(UInt64)  //4
    case ifdrop(UInt64)  //5
    case filterAccept(UInt64)  // 6
    case osDrop(UInt64) //7
    case usrDeliv(UInt64) //8
    // type = nrb
    case dnsName(String)
    case dnsIpv4Address(IPv4Address)
    case dnsIpv6Address(IPv6Address)
    
    static func getCString(length: Int, data: Data) -> String? {
        let cString = data[data.startIndex ..< data.startIndex + length]
        guard var string = String(data: cString, encoding: .utf8) else {
            Pcapng.logger.error("PcapngOption unable to get string from \(cString)")
            return nil
        }
        if let nullIndex = string.firstIndex(of: "\0"){
            Pcapng.logger.error("PcapngOption found null at index \(nullIndex)")
            string.removeSubrange(nullIndex ..< string.endIndex)
        }
        return string
    }
    
    
    init?(code: Int, length: Int, data: Data, type: PcapngOptionType) {
        
        
        
        Pcapng.logger.info("PcapngOption.init code \(code) length \(length) data \(data)")
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
        case (.epb, 2):
            guard data.count >= 4 else {
                return nil
            }
            let flags = Pcapng.getUInt32(data: data)
            self = .flags(flags)
            return
        case (.epb, 3):
            guard data.count >= 1, data.count >= length else {
                return nil
            }
            let algorithm = data[data.startIndex]
            let hash: Data
            switch algorithm {
            case 0:  // 2s complement
                hash = data[data.startIndex + 1 ..< data.startIndex + length]
            case 1:  // XOR
                hash = data[data.startIndex + 1 ..< data.startIndex + length]
            case 2: // CRC32
                guard data.count >= 5 else {
                    return nil
                }
                hash = data[data.startIndex + 1 ..< data.startIndex + 5]
            case 3: // MD5
                guard data.count >= 17 else {
                    return nil
                }
                hash = data[data.startIndex + 1 ..< data.startIndex + 17]
            case 4: // SHA-1
                guard data.count >= 20 else {
                    return nil
                }
                hash = data[data.startIndex + 1 ..< data.startIndex + 21]
            case 5: //Toeplitz
                guard data.count >= 5 else {
                    return nil
                }
                hash = data[data.startIndex + 1 ..< data.startIndex + 5]
            default:
                Pcapng.logger.error("Invalid Epb hash algorithm \(algorithm)")
                return nil
            }
            self = .hash(algorithm: algorithm, hash: hash)
            return
            //case flags(UInt32) //2
            //case hash(type: UInt8, hash: Data) // 3
        //case dropcount(UInt64) // 8
        case (.isb, 2):
            guard data.count >= 8 else {
                return nil
            }
            let startTime = Pcapng.getUInt64(data: data)
            self = .startTime(startTime)
        case (.isb, 3):
            guard data.count >= 8 else {
                return nil
            }
            let endTime = Pcapng.getUInt64(data: data)
            self = .endTime(endTime)
        case (.isb, 4):
            guard data.count >= 8 else {
                return nil
            }
            let ifrecv = Pcapng.getUInt64(data: data)
            self = .ifrecv(ifrecv)
        case (.isb, 5):
            guard data.count >= 8 else {
                return nil
            }
            let ifdrop = Pcapng.getUInt64(data: data)
            self = .ifdrop(ifdrop)
        case (.isb, 6):
            guard data.count >= 8 else {
                return nil
            }
            let filterAccept = Pcapng.getUInt64(data: data)
            self = .filterAccept(filterAccept)
        case (.isb, 7):
            guard data.count >= 8 else {
                return nil
            }
            let osDrop = Pcapng.getUInt64(data: data)
            self = .osDrop(osDrop)
        case (.isb, 8):
            guard data.count >= 8 else {
                return nil
            }
            let usrDeliv = Pcapng.getUInt64(data: data)
            self = .usrDeliv(usrDeliv)
        case (.nrb, 2):  // ns_dnsname
            guard let name = String(data: data[data.startIndex ..< data.startIndex + length], encoding: .utf8) else {
                Pcapng.logger.error("nrb option unable to decode dnsname string from data \(data) length \(length)")
                return nil
            }
            self = .dnsName(name)
        case (.nrb, 3): // ns_dnsIPv4addr
            guard data.count >= 4, let ipv4Address = IPv4Address(data) else {
                Pcapng.logger.error("nrb option 3 unable to decode ipv4 address from \(data)")
                return nil
            }
            self = .dnsIpv4Address(ipv4Address)
        case (.nrb, 4): // ns_dnsIPv4addr
            guard data.count >= 16, let ipv6Address = IPv6Address(data) else {
                Pcapng.logger.error("nrb option 3 unable to decode ipv6 address from \(data)")
                return nil
            }
            self = .dnsIpv6Address(ipv6Address)

            
        default:
            Pcapng.logger.error("unimplemented option code \(code)")
            return nil
        }
    }// init
    
    /*    // type = isb
     case startTime(UInt64) //2
     case endTime(UInt64)  // 3
     case ifrecv(UInt64)  //4
     case ifdrop(UInt64)  //5
     case filterAccept(UInt64)  // 6
     case osDrop(UInt64) //7
     case usrDeliv(UInt64) //8*/
    
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
        case .name(let name):
            return "name \(name)"
        case .description(let description):
            return "description \(description)"
        case .ipv4Address(let ip, let netmask):
            return "ipv4 \(ip.debugDescription) netmask \(netmask.debugDescription)"
        case .ipv6Address(let ip, let prefix):
            return "ipv6 \(ip)/\(prefix)"
        case .macaddr(let mac):
            return "mac-address \(mac)"
        case .euiaddr(let eui):
            return "eui-address \(eui)"
        case .flags(let flags):
            let description = String(format: "flags %x",flags)
            return description
        case .hash(let algorithm, let hash):
            return "algorithm \(algorithm) hash.count \(hash.count)"
        case .dropcount(let count):
            return "dropcount \(count)"
        case .startTime(let startTime):
            return "startTime \(startTime)"
        case .endTime(let endTime):
            return "endtime \(endTime)"
        case .ifrecv(let ifrecv):
            return "ifrecv \(ifrecv)"
        case .ifdrop(let ifdrop):
            return "ifdrop \(ifdrop)"
        case .filterAccept(let filterAccept):
            return "filterAccept \(filterAccept)"
        case .osDrop(let osDrop):
            return "osDrop \(osDrop)"
        case .usrDeliv(let usrDeliv):
            return "usrDeliv \(usrDeliv)"
        case .dnsName(let name):
            return "dnsName \(name)"
        case .dnsIpv4Address(let ip):
            return "dnsIpv4Address \(ip)"
        case .dnsIpv6Address(let ip):
            return "dnsIpv6Address \(ip)"
        }
    }
    
}
