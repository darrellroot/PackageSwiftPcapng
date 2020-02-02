//
//  File.swift
//  
//
//  Created by Darrell Root on 2/1/20.
//

import Foundation

/**
 Structure for PcapNG Section Header Block
 */
struct PcapngShb: CustomStringConvertible {
    let blockType: UInt32
    let blockLength: Int  // encoded as UInt32 in header
    let byteOrderMagic: UInt32
    let majorVersion: UInt16
    let minorVersion: UInt16
    let sectionLength: Int64
    // TODO Options
    
    var description: String {
        let output = String(format: "PcapngShg blockType 0x%x blockTotalLength %d byteOrderMagic 0x%x majorVersion %d minorVersion %d sectionLength %d",blockType, blockLength, byteOrderMagic, majorVersion, minorVersion, sectionLength)
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
        self.sectionLength = Pcapng.getInt64(data: data.advanced(by: 16))
        let finalBlockLength = Pcapng.getUInt32(data: data.advanced(by: Int(blockLength) - 4))
        guard finalBlockLength == blockLength else {
            debugPrint("PcapngShb: firstBlockLength \(blockLength) does not match finalBlockLength \(blockLength)")
            return nil
        }
        let optionsData = data[data.startIndex + 24 ..< data.startIndex + blockLength - 4]
        debugPrint("PcapngShb options data count \(optionsData.count)")
        //TODO initialize options
        
        if verbose {
            debugPrint(self.description)
        }
        
        
    }
}
