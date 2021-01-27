//
//  PcapngIdb.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation

public struct PcapngIdb: CustomStringConvertible {
    public let blockType: UInt32
    public let blockLength: Int  // encoded as UInt32 in header
    public let linkType: Int
    public let snaplen: Int
    public var options: [PcapngOption] = []
    public var timevalue: UInt8 = 6  // set to whatever the if_tsresol is
    // TODO Options
    
    public var description: String {
        var output = String(format: "PcapngIdb blockType 0x%x blockLength %d linkType %x snaplen %x options.count %d\n",blockType, blockLength, linkType, snaplen, options.count)
        for option in options {
            output.append("  \(option.description)\n)")
        }
        return output
    }
    init?(data: Data, verbose: Bool = false) {
        guard data.count >= 20 && data.count % 4 == 0 else {
            Pcapng.logger.error("Pcapidg Section Header Block initializer: Invalid data.count \(data.count)")
            return nil
        }
        let blockType = Pcapng.getUInt32(data: data)
        guard blockType == 1 else {
            Pcapng.logger.error("PcapngIdb: Invalid blocktype \(blockType) should be 1")
            return nil
        }
        self.blockType = blockType
        let blockLength = Int(Pcapng.getUInt32(data: data.advanced(by: 4)))
        guard data.count >= blockLength && blockLength % 4 == 0 else {
            Pcapng.logger.error("PcapngIdb initializer: invalid blockLength \(blockLength) data.count \(data.count)")
            return nil
        }
        self.blockLength = blockLength
        self.linkType = Int(Pcapng.getUInt16(data: data.advanced(by: 8)))
        self.snaplen = Int(Pcapng.getUInt32(data: data.advanced(by: 12)))
        let finalBlockLength = Pcapng.getUInt32(data: data.advanced(by: Int(blockLength) - 4))
        guard finalBlockLength == blockLength else {
            Pcapng.logger.error("PcapngIdb: firstBlockLength \(blockLength) does not match finalBlockLength \(blockLength)")
            return nil
        }
        let optionsData = data[data.startIndex + 16 ..< data.startIndex + blockLength - 4]
        Pcapng.logger.trace("PcapngIdb options data count \(optionsData.count)")

        self.options = PcapngOptions.makeOptions(data: optionsData, type: .idb)

        for option in options {
            if case let PcapngOption.tsresol(value) = option {
                self.timevalue = value
            }
        }
        if verbose {
            debugPrint(self.description)
        }
        
        
    }
}
