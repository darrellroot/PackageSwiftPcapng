//
//  File.swift
//  
//
//  Created by Darrell Root on 2/1/20.
//

import Foundation

public struct Pcapng {
    let originalData: Data
    var done = false     // set to true at end of data or when block size exceeds remaining data size
    public init?(data inputData: Data) {
        self.originalData = inputData
        var data = inputData
        
        while !done {
            guard data.count >= 8 else {
                done = true
                break
            }
            let blockType = getUInt32(data: data)
            print("block type 0x%x",blockType)
            let blockLength = getUInt32(data: data.advanced(by: 4))
            print("blockLength \(blockLength)")
            done = true
        }
        func getSectionHeader() {
            
        }
    }

    /**
     getUInt32 assumes 4 bytes exist in data or it will crash
     */
    func getUInt32(data: Data)-> UInt32 {
        let octet0: UInt32 = UInt32(data[data.startIndex])
        let octet1: UInt32 = UInt32(data[data.startIndex + 1])
        let octet2: UInt32 = UInt32(data[data.startIndex + 2])
        let octet3: UInt32 = UInt32(data[data.startIndex + 3])
        debugPrint(" octet0 \(octet0) octet1 \(octet1) octet2 \(octet2) octet3 \(octet3)")
        return octet0 + octet1 << 8 + octet2 << 16 + octet3 << 24
    }
}
