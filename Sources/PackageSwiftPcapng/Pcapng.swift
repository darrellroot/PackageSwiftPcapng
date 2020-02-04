//
//  File.swift
//  
//
//  Created by Darrell Root on 2/1/20.
//

import Foundation

public struct Pcapng: CustomStringConvertible {
    public let originalData: Data
    var done = false     // set to true at end of data or when block size exceeds remaining data size
    public var segments: [PcapngShb] = []
    
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
        
        while !done {
            guard data.count >= 8 else {
                done = true
                break
            }
            let blockType = Pcapng.getUInt32(data: data)
            print("block type 0x%x",blockType)
            let blockLength = Int(Pcapng.getUInt32(data: data.advanced(by: 4)))
            print("blockLength \(blockLength)")
            switch blockType {
            case 0x0a0d0d0a:
                if let newBlock = PcapngShb(data: data) {
                    debugPrint(newBlock.description)
                    segments.append(newBlock)
                }
            case 1:
                guard let newBlock = PcapngIdb(data: data), let lastSegment = segments.last else {
                    debugPrint("error decoding Idb Block, aborting")
                    done = true
                    break
                }
                debugPrint(newBlock.description)
                lastSegment.interfaces.append(newBlock)
            case 6:
                guard let newBlock = PcapngEpb(data: data), let lastSegment = segments.last else {
                    debugPrint("error decoding Epb Block, aborting")
                    done = true
                    break
                }
                debugPrint(newBlock.description)
                lastSegment.packetBlocks.append(newBlock)
            default:
                debugPrint("default case")
                done = true
            }
            if data.count > blockLength {
                data = data.advanced(by: blockLength)
            } else {
                done = true
            }
        } // while !done
        debugPrint(self.description)
    }

    /**
     getUInt32 assumes 4 bytes exist in data or it will crash
     TODO: implement endian fix
     */
    static func getUInt32(data: Data, verbose: Bool = false)-> UInt32 {
        let octet0: UInt32 = UInt32(data[data.startIndex])
        let octet1: UInt32 = UInt32(data[data.startIndex + 1])
        let octet2: UInt32 = UInt32(data[data.startIndex + 2])
        let octet3: UInt32 = UInt32(data[data.startIndex + 3])
        if verbose { debugPrint(" octet0 \(octet0) octet1 \(octet1) octet2 \(octet2) octet3 \(octet3)") }
        return octet0 + octet1 << 8 + octet2 << 16 + octet3 << 24
    }
    static func getUInt16(data: Data, verbose: Bool = false)-> UInt16 {
        let octet0: UInt16 = UInt16(data[data.startIndex])
        let octet1: UInt16 = UInt16(data[data.startIndex + 1])
        if verbose { debugPrint(" octet0 \(octet0) octet1 \(octet1)") }
        return octet0 + octet1 << 8
    }
    static func getInt64(data: Data)-> Int64 {
        let first4 = getUInt32(data: data)
        let second4 = getUInt32(data: data.advanced(by: 4))
        let bitPattern = UInt64(first4) << 32 + UInt64(second4)
        return Int64(bitPattern: bitPattern)
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
