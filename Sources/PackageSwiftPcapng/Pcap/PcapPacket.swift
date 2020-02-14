//
//  PcapPacket.swift
//  
//
//  Created by Darrell Root on 2/14/20.
//

import Foundation
import Logging

public struct PcapPacket: CustomStringConvertible {
    
    public let seconds: Int
    public let microSeconds: Int
    public let date: Date
    public let capturedLength: Int
    public let originalLength: Int
    public let packetData: Data
    
    public var description: String {
        return "PcapPacket description placeholder"
    }
    init(data: Data) throws {
        guard data.count >= 16 else {
            throw PcapError.insufficientData
        }
        self.seconds = Int(Pcap.getUInt32(data: data))
        self.microSeconds = Int(Pcap.getUInt32(data: data.advanced(by: 4)))
        self.capturedLength = Int(Pcap.getUInt32(data: data.advanced(by: 8)))
        self.originalLength = Int(Pcap.getUInt32(data: data.advanced(by: 12)))
        guard data.count >= self.capturedLength + 16 else {
            throw PcapError.insufficientData
        }
        self.packetData = data[data.startIndex + 16 ..< data.startIndex + 16 + capturedLength]
        
        let time = Double(self.seconds) + Double(self.microSeconds) / 1000000.0
        self.date = Date(timeIntervalSince1970: time)
    }
}
