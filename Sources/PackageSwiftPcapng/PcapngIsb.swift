//
//  PcapngIdb.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation

public struct PcapngIsb: CustomStringConvertible {
    public let blockType: UInt32
    public let blockLength: Int  // encoded as UInt32 in header
    public let interfaceId: Int
    public let timestampHigh: Int
    public let timestampLow: Int
    public var options: [PcapngOption] = []
    public let finalBlockLength: Int
    // TODO Options
    
    public var description: String {
        var output = String(format: "PcapngIsb blockType 0x%x blockLength %d interfaceId %x timestampHigh %x timestampLow %x options.count %d\n",blockType, blockLength, interfaceId, timestampHigh, timestampLow, options.count)
        for option in options {
            output.append("  \(option.description)\n)")
        }
        return output
    }
    init?(data: Data, verbose: Bool = false) {
        guard data.count >= 20 && data.count % 4 == 0 else {
            debugPrint("PcapIsb Interface Statistics Block initializer: Invalid data.count \(data.count)")
            return nil
        }
        let blockType = Pcapng.getUInt32(data: data)
        guard blockType == 5 else {
            debugPrint("PcapngISb: Invalid blocktype 0x%x should be 5", blockType)
            return nil
        }
        self.blockType = blockType
        let blockLength = Int(Pcapng.getUInt32(data: data.advanced(by: 4)))
        guard data.count >= blockLength && blockLength % 4 == 0 else {
            debugPrint("PcapngIsb initializer: invalid blockLength \(blockLength) data.count \(data.count)")
            return nil
        }
        self.blockLength = blockLength
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
