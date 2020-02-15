//
//  Pcap.swift
//  
//
//  Created by Darrell Root on 2/14/20.
//

import Foundation
import Logging

public enum PcapError: Error, CustomStringConvertible {
    case insufficientData
    case badMagicNumber(message: String)
    
    public var localizedDescription: String {
        return self.description
    }
    public var description: String {
        switch self {
            
        case .insufficientData:
            return "Pcap: insufficient data"
        case .badMagicNumber(let message):
            return "Pcap: Bad Magic Number \(message)"
        }
    }
}

public struct Pcap: CustomStringConvertible {
    static var bigEndian = false

    public var description: String = "placeholder"
        
    public let originalData: Data
    public let magicNumber: UInt32
    public let versionMajor: UInt16
    public let versionMinor: UInt16
    public let thiszone: UInt32  // GMT to local correction
    public let sigfigs: UInt32 //accuracy of timestamps
    public let snaplen: UInt32
    public let network: UInt32  // data link type
    //var done = false     // set to true at end of data or when block size exceeds remaining data size
    public var packets: [PcapPacket] = []
    // Note Pcapng.logger = Logger(label: "net.networkmom.pcapng")
    
    public init(data inputData: Data) throws {
        self.originalData = inputData
        let data = inputData
        guard data.count >= 24 else {
            throw PcapError.insufficientData
        }
        let magicNumber = Pcap.getUInt32(data: data)
        self.magicNumber = magicNumber
        switch magicNumber {
        case 0xa1b2c3d4:
            Pcap.bigEndian = false
        case 0xd4c3b2a1:
            Pcap.bigEndian = true
        default:
            let magicString = String(format: "%x",magicNumber)
            throw PcapError.badMagicNumber(message: magicString)
        }
        self.versionMajor = Pcap.getUInt16(data: data.advanced(by: 4))
        self.versionMinor = Pcap.getUInt16(data: data.advanced(by: 6))
        self.thiszone = Pcap.getUInt32(data: data.advanced(by: 8))
        self.sigfigs = Pcap.getUInt32(data: data.advanced(by: 12))
        self.snaplen = Pcap.getUInt32(data: data.advanced(by: 16))
        self.network = Pcap.getUInt32(data: data.advanced(by: 20))
        
        var nextPacketPointer = 24
        
        while nextPacketPointer < (data.count - 16) {
            
            do {
                let packet = try PcapPacket(data: data.advanced(by: nextPacketPointer))
                guard packet.capturedLength > 0 else {
                    return
                }
                self.packets.append(packet)
                nextPacketPointer = nextPacketPointer + 16 + packet.capturedLength
            } catch {
                // this packet is invalid, lets return what we have, if we have anything useful
                if self.packets.count > 0 {
                    return
                } else {
                    throw error
                }
            }
        }
        return
    }
    /**
     getUInt32 assumes 4 bytes exist in data or it will crash
     */
    static func getUInt32(data: Data)-> UInt32 {
        let octet0: UInt32 = UInt32(data[data.startIndex])
        let octet1: UInt32 = UInt32(data[data.startIndex + 1])
        let octet2: UInt32 = UInt32(data[data.startIndex + 2])
        let octet3: UInt32 = UInt32(data[data.startIndex + 3])
        if Pcap.bigEndian == false {
            return octet0 + octet1 << 8 + octet2 << 16 + octet3 << 24
        } else {
            return octet0 << 24 + octet1 << 16 + octet2 << 8 + octet3
        }
    }
    static func getUInt16(data: Data)-> UInt16 {
        let octet0: UInt16 = UInt16(data[data.startIndex])
        let octet1: UInt16 = UInt16(data[data.startIndex + 1])
        if Pcap.bigEndian == false {
            return octet0 + octet1 << 8
        } else {
            return octet0 << 8 + octet1
        }
    }
    static func getInt64(data: Data)-> Int64 {
        let first4 = getUInt32(data: data)
        let second4 = getUInt32(data: data.advanced(by: 4))
        if Pcap.bigEndian == false {
            return Int64(UInt64(first4) << 32 + UInt64(second4))
        } else {
            return Int64(UInt64(first4) + UInt64(second4) << 32)
        }
    }
    static func getUInt64(data: Data)-> UInt64 {
        let first4 = getUInt32(data: data)
        let second4 = getUInt32(data: data.advanced(by: 4))
        if Pcap.bigEndian == false {
            return UInt64(first4) << 32 + UInt64(second4)
        } else {
            return UInt64(first4) + UInt64(second4) << 32
        }
    }
    static func getCStrings(data: Data) -> [String] {
        guard let bigString = String(data: data, encoding: .utf8) else {
            Pcapng.logger.error("Unable to decode strings from data \(data)")
            return []
        }
        let substrings = bigString.split(separator: "\0", omittingEmptySubsequences: true)
        return substrings.map{String($0)}
    }

    
    /**
     Returns number of bytes necessary to pad the passed in integer to a multiple of 4.  Used to pad to 32-bit boundaries.
     */
    static func paddingTo4(_ length: Int) -> Int {
        switch length % 4 {  //option field padded to 32 bits
        case 0:
            return 0
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 1
        default: // should never get here
            return 0
        }
    }

}
