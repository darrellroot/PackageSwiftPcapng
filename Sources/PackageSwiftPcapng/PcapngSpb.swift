//
//  PcapngEpb.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation

/**
Structure for PcapNG Simple Packet Block
*/
public struct PcapngSpb: CustomStringConvertible, PcapngPacket {
    public let blockType: UInt32
    public let blockLength: Int  // encoded as UInt32 in header
    public let originalLength: Int
    public let packetData: Data  // packet data
    public let finalBlockLength: Int
    // TODO Options
    
    public var description: String {
        let output = String(format: "PcapngSpb blockType 0x%x blockLength %d packetData.count %d \n",blockType, blockLength, packetData.count)
        return output
    }
    init?(data: Data, snaplen: Int, verbose: Bool = false) {
        guard data.count >= 32 && data.count % 4 == 0 else {
            Pcapng.logger.error("PcapngSpb Simple Packet Block initializer: Invalid data.count \(data.count)")
            return nil
        }
        let blockType = Pcapng.getUInt32(data: data)
        guard blockType == 3 else {
            Pcapng.logger.error("PcapngSpb: Invalid blocktype \(blockType) should be 6")
            return nil
        }
        self.blockType = blockType
        let blockLength = Int(Pcapng.getUInt32(data: data.advanced(by: 4)))
        guard data.count >= blockLength && blockLength % 4 == 0 else {
            Pcapng.logger.error("PcapngSpb initializer: invalid blockLength \(blockLength) data.count \(data.count)")
            return nil
        }
        self.blockLength = blockLength
        let originalLength = Int(Pcapng.getUInt32(data: data.advanced(by: 8)))
        self.originalLength = originalLength
        guard data.count >= snaplen + 16 else {
            Pcapng.logger.error("PcapngSpb initializer: snaplen \(snaplen) does not match data \(data.count)")
            return nil
        }
        if snaplen == 0 {
            self.packetData = data[data.startIndex + 12 ..< data.startIndex + 12 + originalLength]
        } else {
            let minLength = min(snaplen, originalLength)
            self.packetData = data[data.startIndex + 12 ..< data.startIndex + 12 + minLength]
        }
        self.finalBlockLength = Int(Pcapng.getUInt32(data: data.advanced(by: Int(blockLength) - 4)))
        guard finalBlockLength == blockLength else {
            Pcapng.logger.error("PcapngSpb: firstBlockLength \(blockLength) does not match finalBlockLength \(blockLength)")
            return nil
        }

        if verbose {
            debugPrint(self.description)
        }
        
        
    }
}
