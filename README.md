# PackageSwiftPcapng

**Warning: PackageSwiftPcapng is a 0.x release.  The API and resulting data structure are not guaranteed to be stable.**

.pcapng files encode network packet captures.  .pcapng replaces the older .pcap file format and is the default output format used by Wireshark.  The pcapng file format is documented at https://github.com/pcapng/pcapng/   A set of test .pcapng files for decode is at https://github.com/hadrielk/pcapng-test-generator

This package takes a stream of Data (presumably of a .pcapng data file) and attempts to decode it with a failable initializer, gnerating a Pcapng data structure:

        let data = try Data(contentsOf: url)
        let pcapng = Pcapng(data: data)

PackageSwiftPcapng uses Apple's swift-log API for logging.  See https://github.com/apple/swift-log
Bootstrapping the logging system is not required to use PackageSwiftPcapng.

At this time PackageSwiftPcapng is read-only, and does not support creating .pcapng files.

To use PackageSwiftPcapng in your project, add PackageSwiftPcap to your project and add the following imports:

    import PackageSwiftPcapng
    import Logging  (optional)

The Pcapng data structure follows the hierarchy of the .pcapng data format:

    public struct Pcapng
        public var segments: [PcapngShb]
            public var options: [PcapngOption]
            public var interfaces: [PcapngIsb]
            public var nameResolutions: [PcapngNrb]
            public var customBlocks: [PcapngCb]
            public var packetBlocks: [PcapngPacket]
        
PcapngPacket is a protocol with an implementation for each type of packet block supported by .pcapng.  In particular, the packet (actually full frame) data itself is available to be fed into a decoder.  Note that this data may not be the full frame size depending on the SNAPLEN when the capture occurred (the captured SNAPLEN is in the interfaces data structure).

    public protocol PcapngPacket: CustomStringConvertible {
        var blockType: UInt32 { get }
        var blockLength: Int { get }
        var originalLength: Int { get }
        var packetData: Data { get }
        var finalBlockLength: Int { get }
        var description: String { get }
    }

    public class PcapngEpb  (Enhanced Packet block)
    public class PcapngSpb  (Simple Packet block)

"Simple" pcapng files have one segment, one interface, and multiple packets captured from that interface.  Here's an example of grabbing the array of PcapngPacket from a 1-segment 1-interface .pcapng and feeding it into the PackageEtherCapture frame decoder for analysis:

        guard let packetBlocks = pcapng?.segments.first?.packetBlocks else {
            print("Error: unable to get packets from decoding PCAPNG file \(url)")
            exit(EXIT_FAILURE)
        }
        for (count,packet) in packetBlocks.enumerated() {
            let frame = Frame(data: packet.packetData)
            displayFrame(frame: frame, packetCount: Int32(count), arguments: arguments)
        }

The above code segment is from the CLI version of etherdump https://github.com/darrellroot/etherdump
The frame decoder is from PackageEtherCapture https://github.com/darrellroot/PackageEtherCapture
