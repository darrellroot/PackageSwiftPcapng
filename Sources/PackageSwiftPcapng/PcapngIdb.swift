//
//  PcapngIdb.swift
//  
//
//  Created by Darrell Root on 2/2/20.
//

import Foundation

public struct PcapngIdb: CustomStringConvertible {
    let blockType: UInt32
    let blockLength: Int  // encoded as UInt32 in header
    let linkType: Int
    let snaplen: Int
    var options: [PcapngOption] = []
    // TODO Options
    
    public var description: String {
        let output = String(format: "PcapngIdb blockType 0x%x blockLength %d linkType %x snaplen %x options.count %d",blockType, blockLength, linkType, snaplen, options.count)
        return output
    }
    init?(data: Data, verbose: Bool = false) {
        guard data.count >= 20 && data.count % 4 == 0 else {
            debugPrint("Pcapidg Section Header Block initializer: Invalid data.count \(data.count)")
            return nil
        }
        let blockType = Pcapng.getUInt32(data: data)
        guard blockType == 1 else {
            debugPrint("PcapngIdb: Invalid blocktype 0x%x should be 1", blockType)
            return nil
        }
        self.blockType = blockType
        let blockLength = Int(Pcapng.getUInt32(data: data.advanced(by: 4)))
        guard data.count >= blockLength && blockLength % 4 == 0 else {
            debugPrint("PcapngIdb initializer: invalid blockLength \(blockLength) data.count \(data.count)")
            return nil
        }
        self.blockLength = blockLength
        self.linkType = Int(Pcapng.getUInt16(data: data.advanced(by: 8)))
        self.snaplen = Int(Pcapng.getUInt16(data: data.advanced(by: 12)))
        let finalBlockLength = Pcapng.getUInt32(data: data.advanced(by: Int(blockLength) - 4))
        guard finalBlockLength == blockLength else {
            debugPrint("PcapngIdb: firstBlockLength \(blockLength) does not match finalBlockLength \(blockLength)")
            return nil
        }
        let optionsData = data[data.startIndex + 16 ..< data.startIndex + blockLength - 4]
        debugPrint("PcapngIdb options data count \(optionsData.count)")

        self.options = PcapngOptions.makeOptions(data: optionsData, type: .idb)

        if verbose {
            debugPrint(self.description)
        }
        
        
    }
}
