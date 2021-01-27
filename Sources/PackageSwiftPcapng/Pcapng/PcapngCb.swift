//
//  PcapngIdb.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation
import Logging

public struct PcapngCb: CustomStringConvertible {
    public let blockType: UInt32
    public let blockLength: Int  // encoded as UInt32 in header
    public let enterpriseNumber: Int
    public let customDataAndOptions: Data
    // TODO Options
    
    public var description: String {
        let output = String(format: "PcapngCb blockType 0x%x blockLength %d enterpriseNumber %d customDataCount %d\n",blockType, blockLength, enterpriseNumber, customDataAndOptions.count)
        return output
    }
    init?(data: Data, verbose: Bool = false) {
        guard data.count >= 16 && data.count % 4 == 0 else {
            Pcapng.logger.error("PcapCb Custom Block initializer: Invalid data.count \(data.count)")
            return nil
        }
        let blockType = Pcapng.getUInt32(data: data)
        guard blockType == 0xbad || blockType == 0x40000bad else {
            Pcapng.logger.error("Pcapngcb: Invalid blocktype \(blockType) should be 0xbad or 0x40000bad")
            return nil
        }
        self.blockType = blockType
        let blockLength = Int(Pcapng.getUInt32(data: data.advanced(by: 4)))
        guard data.count >= blockLength && blockLength % 4 == 0 else {
            Pcapng.logger.error("PcapngIdb initializer: invalid blockLength \(blockLength) data.count \(data.count)")
            return nil
        }
        self.blockLength = blockLength
        self.enterpriseNumber = Int(Pcapng.getUInt32(data: data.advanced(by: 8)))
        self.customDataAndOptions = data[data.startIndex + 12 ..< data.startIndex + blockLength - 4]
        let finalBlockLength = Pcapng.getUInt32(data: data.advanced(by: Int(blockLength) - 4))
        guard finalBlockLength == blockLength else {
            Pcapng.logger.error("PcapngCb: firstBlockLength \(blockLength) does not match finalBlockLength \(blockLength)")
            return nil
        }
        if verbose {
            debugPrint(self.description)
        }
        
        
    }
}
