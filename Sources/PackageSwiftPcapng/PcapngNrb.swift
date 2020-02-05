//
//  PcapngNrb.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation
import Network

public struct PcapngNrb: CustomStringConvertible {
    public let blockType: UInt32
    public let blockLength: Int  // encoded as UInt32 in header
    public let ipv4records: [IPv4Address:[String]] = [:]
    public let ipv6records: [IPv6Address:[String]] = [:]
    public var options: [PcapngOption] = []
    public let finalBlockLength: Int
    // TODO Options
    
    public var description: String {
        var output = String(format: "PcapngNrb blockType 0x%x blockLength %d ipv4records %d ipv6records %dx options.count %d\n",blockType, blockLength, ipv4records.keys.count, ipv6records.keys.count, options.count)
        for key in ipv4records.keys {
            output.append(" \(key) \(ipv4records[key]")
        }
        for key in ipv6records.keys {
            output.append(" \(key) \(ipv4records[key]")
        }
        for option in options {
            output.append("  \(option.description)\n)")
        }
        return output
    }
    init?(data: Data, verbose: Bool = false) {
        guard data.count >= 12 && data.count % 4 == 0 else {
            debugPrint("PcapNrb Name Resolution Block initializer: Invalid data.count \(data.count)")
            return nil
        }
        let blockType = Pcapng.getUInt32(data: data)
        guard blockType == 4 else {
            debugPrint("PcapngNrb: Invalid blocktype 0x%x should be 4", blockType)
            return nil
        }
        self.blockType = blockType
        let blockLength = Int(Pcapng.getUInt32(data: data.advanced(by: 4)))
        guard data.count >= blockLength && blockLength % 4 == 0 else {
            debugPrint("PcapngNrb initializer: invalid blockLength \(blockLength) data.count \(data.count)")
            return nil
        }
        self.blockLength = blockLength
        let finalBlockLength = Int(Pcapng.getUInt32(data: data.advanced(by: blockLength - 4)))
        guard finalBlockLength == blockLength else {
            debugPrint("PcapNrb initializer: blockLength \(blockLength) finalBlockLength \(finalBlockLength)")
            return nil
        }
        
        var lastRecord = false
        var recordData = data.advanced(by: 8)
        
        while !lastRecord {
            let recordType = Pcapng.getUInt16(data: recordData)
            let recordLength = Pcapng.getUInt16(data: recordData.advanced(by:2))
            switch recordType {
            case 0: // nrb_record_end
                recordData = recordData.advanced(by: 4)
                lastRecord = true
            case 1: // nrb_record_ipv4
                guard recordLength >= 6 else {
                    debugPrint("PcapNrb initializer: invalid record length \(recordLength)")
                    return nil
                }
                let ipv4Data = recordData[recordData.startIndex + 4 ..< recordData.startIndex + 8]
                let ipv4Address = IPv4Address(data: ipv4Data)
                let cStringData = recordData[recordData.startIndex + 8 ..< recordData.startIndex + 4 + recordLength]
                let strings = Pcapng.getCStrings(data: cStringData)
                self.ipv4records[ipv4Address] = strings
                recordData = recordData.advanced(by: recordLength + 4)
            case 2:
                guard recordLength >= 18 else {
                    debugPrint("PcapNrb initializer: invalid record length \(recordLength)")
                    return nil
                }
                let ipv6Data = recordData[recordData.startIndex + 4 ..< recordData.startIndex + 20]
                let ipv4Address = IPv4Address(data: ipv4Data)
                let cStringData = recordData[recordData.startIndex + 20 ..< recordData.startIndex + 4 + recordLength]
                let strings = Pcapng.getCStrings(data: cStringData)
                self.ipv6records[ipv6Address] = strings
                recordData = recordData.advanced(by: recordLength + 4)
            default:
                // need to deal with future cases
                debugPrint("PcapngNrb unknown record type \(recordType)")
                recordData = recordData.advanced(by: recordLength + 4)
            }// switch recordType
        }// while !lastRecord
        let optionsData = data[data.startIndex + 16 ..< data.startIndex + blockLength - 4]
        debugPrint("PcapngNrb options data count \(optionsData.count)")

        self.options = PcapngOptions.makeOptions(data: optionsData, type: .idb)

        
        
        self.interfaceId = Int(Pcapng.getUInt32(data: data.advanced(by: 8)))
        self.timestampHigh = Int(Pcapng.getUInt32(data: data.advanced(by: 12)))
        self.timestampLow = Int(Pcapng.getUInt32(data: data.advanced(by: 16)))
        let finalBlockLength = Int(Pcapng.getUInt32(data: data.advanced(by: Int(blockLength) - 4)))
        guard finalBlockLength == blockLength else {
            debugPrint("PcapngIsb: firstBlockLength \(blockLength) does not match finalBlockLength \(blockLength)")
            return nil
        }
        self.finalBlockLength = finalBlockLength
        let optionsData = data[data.startIndex + 20 ..< data.startIndex + blockLength - 4]
        debugPrint("PcapngIsb options data count \(optionsData.count)")

        self.options = PcapngOptions.makeOptions(data: optionsData, type: .isb)

        if verbose {
            debugPrint(self.description)
        }
        
        
    }
}
