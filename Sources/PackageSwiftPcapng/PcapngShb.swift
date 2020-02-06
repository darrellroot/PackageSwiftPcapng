//
//  File.swift
//  
//
//  Created by Darrell Root on 2/1/20.
//

import Foundation

/**
 Class for PcapNG Section Header Block
 */
public class PcapngShb: CustomStringConvertible {
    public let blockType: UInt32
    public let blockLength: Int  // encoded as UInt32 in header
    public let byteOrderMagic: UInt32
    public let majorVersion: UInt16
    public let minorVersion: UInt16
    public let sectionLength: UInt64
    public var options: [PcapngOption] = []
    public var interfaces: [PcapngIdb] = []
    public var interfaceStatistics: [PcapngIsb] = []
    public var nameResolutions: [PcapngNrb] = []
    public var customBlocks: [PcapngCb] = []
    public var packetBlocks: [PcapngPacket] = []
    // TODO Options
    
    public var description: String {
        var output = String(format: "PcapngShg blockType 0x%x blockTotalLength %d byteOrderMagic 0x%x majorVersion %d minorVersion %d sectionLength %d options.count %d\n interfaces.count %d interfaceStatistics %d nameResolutions %d packetBlocks.count %d customBlocks %d",blockType, blockLength, byteOrderMagic, majorVersion, minorVersion, sectionLength, options.count, interfaces.count, interfaceStatistics.count, nameResolutions.count, packetBlocks.count, customBlocks.count)
        for option in options {
            output.append("  \(option.description)\n")
        }
        return output
    }
    init?(data: Data, verbose: Bool = false) {

        guard data.count >= 28 && data.count % 4 == 0 else {
            debugPrint("Pcapng Section Header Block initializer: Invalid data.count \(data.count)")
            return nil
        }
        let blockType = Pcapng.getUInt32(data: data)
        guard blockType == 0x0a0d0d0a else {
            debugPrint("PcapngShb: Invalid blocktype 0x%x should be 0x0a0d0d0a", blockType)
            return nil
        }
        self.blockType = blockType
        let blockLength = Int(Pcapng.getUInt32(data: data.advanced(by: 4)))
        guard data.count >= blockLength && blockLength % 4 == 0 else {
            debugPrint("PcapngShb initializer: invalid blockLength \(blockLength) data.count \(data.count)")
            return nil
        }
        self.blockLength = blockLength
        let byteOrderMagic = Pcapng.getUInt32(data: data.advanced(by: 8))
        self.byteOrderMagic = byteOrderMagic
        guard byteOrderMagic == 0x1A2B3C4D || byteOrderMagic == UInt32(0x1A2B3C4D).byteSwapped else {
            debugPrint("PcapngShb invalid byteOrderMagic %x should be 0x1A2B3C4D or %x",byteOrderMagic,UInt32(0x1A2B3C4D).byteSwapped)
            return nil
        }
        self.majorVersion = Pcapng.getUInt16(data: data.advanced(by: 12))
        self.minorVersion = Pcapng.getUInt16(data: data.advanced(by: 14))
        self.sectionLength = Pcapng.getUInt64(data: data.advanced(by: 16))
        let finalBlockLength = Pcapng.getUInt32(data: data.advanced(by: Int(blockLength) - 4))
        guard finalBlockLength == blockLength else {
            debugPrint("PcapngShb: firstBlockLength \(blockLength) does not match finalBlockLength \(blockLength)")
            return nil
        }
        let optionsData = data[data.startIndex + 24 ..< data.startIndex + blockLength - 4]
        debugPrint("PcapngShb options data count \(optionsData.count)")

        self.options = PcapngOptions.makeOptions(data: optionsData, type: .shb)

        debugPrint(self.description)
        
    }
}
