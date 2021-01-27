//
//  PcapngEpb.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation

public class PcapngEpb: CustomStringConvertible, PcapngPacket {
    public let blockType: UInt32
    public let blockLength: Int  // encoded as UInt32 in header
    public let interfaceId: Int
    //public let timestampHigh: Int
    //public let timestampLow: Int
    public let timestamp: UInt64
    public var date: Date? = nil // set by parent after initialization
    public let capturedLength: Int
    public let originalLength: Int
    public let packetData: Data  // packet data
    public var options: [PcapngOption] = []
    public let finalBlockLength: Int
    // TODO Options
    
    public var description: String {
        var output = String(format: "PcapngEpb blockType 0x%x blockLength %d interfaceId %x timestamp %d capturedLength %d originalLength %d packetData.count %d options.count %d\n",blockType, blockLength, interfaceId, timestamp, capturedLength, originalLength, packetData.count, options.count)
        for option in options {
            output.append("  \(option.description)\n)")
        }
        return output
    }
    init?(data: Data, verbose: Bool = false) {
        guard data.count >= 32 && data.count % 4 == 0 else {
            Pcapng.logger.error("PcapEpb Section Header Block initializer: Invalid data.count \(data.count)")
            return nil
        }
        let blockType = Pcapng.getUInt32(data: data)
        guard blockType == 6 else {
            Pcapng.logger.error("PcapngEpb: Invalid blocktype \(blockType) should be 6")
            return nil
        }
        self.blockType = blockType
        let blockLength = Int(Pcapng.getUInt32(data: data.advanced(by: 4)))
        guard data.count >= blockLength && blockLength % 4 == 0 else {
            Pcapng.logger.error("PcapngIdb initializer: invalid blockLength \(blockLength) data.count \(data.count)")
            return nil
        }
        self.blockLength = blockLength
        self.interfaceId = Int(Pcapng.getUInt32(data: data.advanced(by: 8)))
        let timestampHigh = Pcapng.getUInt32(data: data.advanced(by: 12))
        let timestampLow = Pcapng.getUInt32(data: data.advanced(by: 16))
        self.timestamp = UInt64(timestampHigh) << 32 + UInt64(timestampLow)
        let capturedLength = Int(Pcapng.getUInt32(data: data.advanced(by: 20)))
        self.capturedLength = capturedLength
        self.originalLength = Int(Pcapng.getUInt32(data: data.advanced(by: 24)))
        self.packetData = data[data.startIndex + 28 ..< data.startIndex + 28 + capturedLength]
        self.finalBlockLength = Int(Pcapng.getUInt32(data: data.advanced(by: Int(blockLength) - 4)))
        guard finalBlockLength == blockLength else {
            Pcapng.logger.error("PcapngIdb: firstBlockLength \(blockLength) does not match finalBlockLength \(blockLength)")
            return nil
        }
        let optionsData = data[data.startIndex + 28 + capturedLength + Pcapng.paddingTo4(capturedLength) ..< data.startIndex + blockLength - 4]
        Pcapng.logger.trace("PcapngEpb options data count \(optionsData.count)")

        self.options = PcapngOptions.makeOptions(data: optionsData, type: .epb)

        if verbose {
            debugPrint(self.description)
        }
        
        
    }
}
