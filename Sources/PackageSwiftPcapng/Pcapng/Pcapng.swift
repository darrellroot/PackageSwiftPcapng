//
//  File.swift
//  
//
//  Created by Darrell Root on 2/1/20.
//

import Foundation
import Logging

public struct Pcapng: CustomStringConvertible {
    static let version = "PackageSwiftPcapng version 0.0.1"
    public let originalData: Data
    var done = false     // set to true at end of data or when block size exceeds remaining data size
    public var segments: [PcapngShb] = []
    static var bigEndian = false
    public static var logger = Logger(label: "net.networkmom.pcapng")
    
    public var description: String {
        var output: String = "Pcapng segments \(segments.count)"
        for (count,segment) in segments.enumerated() {
            output.append("  segment\(count) options \(segment.options.count) interfaces \(segment.interfaces.count) packetBlocks \(segment.packetBlocks.count)")
        }
        return output
    }
    public init?(data inputData: Data) {
        self.originalData = inputData
        var data = inputData
        guard data.count >= 28 else {
            Pcapng.logger.error("Pcapng: Insufficient data \(data.count) bytes")
            return nil
        }
        // byteOrderMagic
        if data[8] == 0x1a && data[9] == 0x2b && data[10] == 0x3c && data[11] == 0x4d {
            Pcapng.bigEndian = true
        } else {
            Pcapng.bigEndian = false
        }
        var position = 0
        while !done {
            guard data.count - position >= 8 else {
                done = true
                break
            }
            let blockType = Pcapng.getUInt32(data: data[data.startIndex + position ..< data.startIndex + position + 4])
            Pcapng.logger.debug("block type \(blockType)")
            let blockLength = Int(Pcapng.getUInt32(data: data[data.startIndex + position + 4 ..< data.startIndex + position + 8]))
            Pcapng.logger.debug("blockLength \(blockLength)")
            switch blockType {
            case 0x0a0d0d0a:
                // Deal with case where endianness changes per section
                if data[data.startIndex + position + 8] == 0x1a && data[data.startIndex + position + 9] == 0x2b && data[data.startIndex + position + 10] == 0x3c && data[data.startIndex + position + 11] == 0x4d {
                    Pcapng.bigEndian = true
                } else {
                    Pcapng.bigEndian = false
                }

                if let newBlock = PcapngShb(data: data[data.startIndex + position ..< data.startIndex + position + blockLength]) {
                    Pcapng.logger.info("\(newBlock.description)")
                    segments.append(newBlock)
                }
            case 1:
                guard let newBlock = PcapngIdb(data: data[data.startIndex + position ..< data.startIndex + position + blockLength]), let lastSegment = segments.last else {
                    Pcapng.logger.error("error decoding Idb Block, aborting")
                    done = true
                    break
                }
                Pcapng.logger.info("\(newBlock.description)")
                lastSegment.interfaces.append(newBlock)
            case 3:
                guard let lastSegment = segments.last, let firstInterface = lastSegment.interfaces.first, let newBlock = PcapngSpb(data: data[data.startIndex + position ..< data.startIndex + position + blockLength], snaplen: firstInterface.snaplen) else {
                    Pcapng.logger.error("error decoding Spb Block, aborting")
                    done = true
                    break
                }
                Pcapng.logger.info("\(newBlock.description)")
                lastSegment.packetBlocks.append(newBlock as PcapngPacket)
            case 4:
                guard let newBlock = PcapngNrb(data: data[data.startIndex + position ..< data.startIndex + position + blockLength]), let lastSegment = segments.last else {
                    Pcapng.logger.error("error decoding Nrb Block, aborting")
                    done = true
                    break
                }
                Pcapng.logger.info("\(newBlock.description)")
                lastSegment.nameResolutions.append(newBlock)
            case 5:
                guard let newBlock = PcapngIsb(data: data[data.startIndex + position ..< data.startIndex + position + blockLength]), let lastSegment = segments.last else {
                    Pcapng.logger.error("error decoding Isb Block, aborting")
                    done = true
                    break
                }
                Pcapng.logger.info("\(newBlock.description)")
                lastSegment.interfaceStatistics.append(newBlock)
            case 6:
                guard let newBlock = PcapngEpb(data: data[data.startIndex + position ..< data.startIndex + position + blockLength]), let lastSegment = segments.last else {
                    Pcapng.logger.error("error decoding Epb Block, aborting")
                    done = true
                    break
                }
                Pcapng.logger.info("\(newBlock.description)")
                lastSegment.packetBlocks.append(newBlock as PcapngPacket)
            case 0xbad, 0x40000bad:
                guard let newBlock = PcapngCb(data: data[data.startIndex + position ..< data.startIndex + position + blockLength]), let lastSegment = segments.last else {
                    Pcapng.logger.error("error decoding custom Block, aborting")
                    done = true
                    break
                }
                Pcapng.logger.info("\(newBlock.description)")
                lastSegment.customBlocks.append(newBlock)
            case 0x80000001:
                Pcapng.logger.info("Pcapng: Darwin process event block, ignoring")
                
            default:
                Pcapng.logger.error("Pcapng: default case blockType \(blockType)")
                done = true
            }
            position = position + blockLength
        } // while !done
        for segment in segments {
            segment.updateDates()
        }
        Pcapng.logger.info("\(self.description)")
    }

    /**
     getUInt32 assumes 4 bytes exist in data or it will crash
     */
    static func getUInt32(data: Data)-> UInt32 {
        let octet0: UInt32 = UInt32(data[data.startIndex])
        let octet1: UInt32 = UInt32(data[data.startIndex + 1])
        let octet2: UInt32 = UInt32(data[data.startIndex + 2])
        let octet3: UInt32 = UInt32(data[data.startIndex + 3])
        if Pcapng.bigEndian == false {
            return octet0 + octet1 << 8 + octet2 << 16 + octet3 << 24
        } else {
            return octet0 << 24 + octet1 << 16 + octet2 << 8 + octet3
        }
    }
    static func getUInt16(data: Data)-> UInt16 {
        let octet0: UInt16 = UInt16(data[data.startIndex])
        let octet1: UInt16 = UInt16(data[data.startIndex + 1])
        if Pcapng.bigEndian == false {
            return octet0 + octet1 << 8
        } else {
            return octet0 << 8 + octet1
        }
    }
    static func getInt64(data: Data)-> Int64 {
        let first4 = getUInt32(data: data)
        let second4 = getUInt32(data: data[data.startIndex + 4 ..< data.startIndex + 8])
        if Pcapng.bigEndian == false {
            return Int64(UInt64(first4) << 32 + UInt64(second4))
        } else {
            return Int64(UInt64(first4) + UInt64(second4) << 32)
        }
    }
    static func getUInt64(data: Data)-> UInt64 {
        let first4 = getUInt32(data: data)
        let second4 = getUInt32(data: data[data.startIndex + 4 ..< data.startIndex + 8])
        if Pcapng.bigEndian == false {
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
