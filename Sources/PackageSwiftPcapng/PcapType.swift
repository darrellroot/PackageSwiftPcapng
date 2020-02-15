//
//  PcapType.swift
//  
//
//  Created by Darrell Root on 2/14/20.
//

import Foundation

public enum PcapType {
    case pcap
    case pcapng
    case neither
    
    public static func detect(data: Data) -> PcapType {
        guard data.count >= 4 else {
            return .neither
        }
        let blockType = Pcapng.getUInt32(data: data)
        
        switch blockType {
        case 0x0a0d0d0a:
            return .pcapng
        case 0xa1b2c3d4, 0xd4c3b2a1:
            return .pcap
        default:
            return .neither
        }
    }
}
