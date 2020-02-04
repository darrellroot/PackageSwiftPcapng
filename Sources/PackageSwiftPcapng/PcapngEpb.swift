//
//  PcapngEpb.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation

public struct PcapngEpb: CustomStringConvertible {
    public let blockType: UInt32
    public let blockLength: Int  // encoded as UInt32 in header
    public let interfaceId: Int
    public let timestampHigh: Int
    public let timestampLow: Int
    public let capturedLength: Int
    public let originalLength: Int
    public let packetData: Data  // packet data
    public var options: [PcapngOption] = []
    public let finalBlockLength: Int
    // TODO Options
    
    public var description: String {
        var output = String(format: "PcapngEpb blockType 0x%x blockLength %d interfaceId %x timestampHigh %d timestampLow %d capturedLength %d originalLength %d packetData.count %d options.count %d\n",blockType, blockLength, interfaceId, timestampHigh, timestampLow, capturedLength, originalLength, packetData.count, options.count)
        for option in options {
            output.append("  \(option.description)\n)")
        }
        return output
    }
    init?(data: Data, verbose: Bool = false) {
        guard data.count >= 32 && data.count % 4 == 0 else {
            debugPrint("PcapEpb Section Header Block initializer: Invalid data.count \(data.count)")
            return nil
        }
        let blockType = Pcapng.getUInt32(data: data)
        guard blockType == 6 else {
            debugPrint("PcapngEpb: Invalid blocktype 0x%x should be 6", blockType)
            return nil
        }
        self.blockType = blockType
        let blockLength = Int(Pcapng.getUInt32(data: data.advanced(by: 4)))
        guard data.count >= blockLength && blockLength % 4 == 0 else {
            debugPrint("PcapngIdb initializer: invalid blockLength \(blockLength) data.count \(data.count)")
            return nil
        }
        self.blockLength = blockLength
        self.interfaceId = Int(Pcapng.getUInt32(data: data.advanced(by: 8)))
        self.timestampHigh = Int(Pcapng.getUInt32(data: data.advanced(by: 12)))
        self.timestampLow = Int(Pcapng.getUInt32(data: data.advanced(by: 16)))
        let capturedLength = Int(Pcapng.getUInt32(data: data.advanced(by: 20)))
        self.capturedLength = capturedLength
        self.originalLength = Int(Pcapng.getUInt32(data: data.advanced(by: 24)))
        self.packetData = data[data.startIndex + 28 ..< data.startIndex + 28 + capturedLength]
        self.finalBlockLength = Int(Pcapng.getUInt32(data: data.advanced(by: Int(blockLength) - 4)))
        guard finalBlockLength == blockLength else {
            debugPrint("PcapngIdb: firstBlockLength \(blockLength) does not match finalBlockLength \(blockLength)")
            return nil
        }
        let optionsData = data[data.startIndex + 28 + capturedLength + Pcapng.paddingTo4(capturedLength) ..< data.endIndex - 4]
        debugPrint("PcapngEpb options data count \(optionsData.count)")

        self.options = PcapngOptions.makeOptions(data: optionsData, type: .epb)

        if verbose {
            debugPrint(self.description)
        }
        
        
    }
}
