import XCTest
import Network
@testable import PackageSwiftPcapng

final class PackageSwiftPcapngBasicBeTests: XCTestCase {
    // For testing get files from https://github.com/hadrielk/pcapng-test-generator
    // and point the test suite at it
    let directory = "/Users/droot/Dropbox/programming/projects-github/pcapng-test-generator/output_be/basic/"
    func test001Be() {
        let path = directory + "test001.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
        XCTAssert(pcapng.segments.first?.interfaces.first?.options.first?.description == "name silly ethernet interface")
        XCTAssert(pcapng.segments.first?.interfaces.first?.options.count == 2)
        }
    }
    
    func test002Be() {
        let path = directory + "test002.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 0)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 0)
            
        }
    }

    func test003Be() {
        let path = directory + "test003.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 0)
            XCTAssert(pcapng.segments.first?.options[0].description == "hardware Apple MBP")
        }
    }
    
    func test004Be() {
        let path = directory + "test004.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 2)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
            XCTAssert(pcapng.segments.first?.interfaces.first?.snaplen == 96)
            XCTAssert(pcapng.segments.first?.interfaces[1].snaplen == 128)
            guard let packet = pcapng.segments.first?.packetBlocks[1] as? PcapngEpb else {
                XCTFail()
                return
            }
            XCTAssert(packet.interfaceId == 1)
            XCTAssert(packet.originalLength == 342)
            XCTAssert(packet.capturedLength == 128)
        }
    }

    func test005Be() {
        let path = directory + "test005.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 2)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
            XCTAssert(pcapng.segments.first?.majorVersion == 1)
            XCTAssert(pcapng.segments.first?.minorVersion == 0)
            XCTAssert(pcapng.segments.first?.options.count == 5)
            XCTAssert(pcapng.segments.first?.interfaces.first?.linkType == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks[3].packetData.count == 128)
            XCTAssert(pcapng.segments.first?.packetBlocks[2].packetData.count == 96)

        }
    }

    func test006Be() {
        let path = directory + "test006.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 2)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 5)
        }
    }

    func test007Be() {
        let path = directory + "test007.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 1)
        }
    }


    func test008Be() {
        let path = directory + "test008.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 2)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
            XCTAssert(pcapng.segments.first?.interfaces[1].snaplen == 128)
            XCTAssert(pcapng.segments.first?.interfaces[1].options[2].description == "ipv4 10.1.2.4 netmask 255.255.255.0")
            XCTAssert(pcapng.segments.first?.interfaces[0].options[4].description == "ipv6 2100:db8::1a2b/64")

        }
    }

    func test009Be() {
        let path = directory + "test009.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 2)
        }
    }
    
    func test010Be() {
        let path = directory + "test010.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
            guard let packet = pcapng.segments.first?.packetBlocks[3] as? PcapngSpb else {
                XCTFail()
                return
            }
            XCTAssert(packet.originalLength == 342)
            XCTAssert(packet.packetData.count == 342)
        }
    }

    func test011Be() {
        let path = directory + "test011.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
        }
    }

    func test012Be() {
        let path = directory + "test012.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
            guard let packet0 = pcapng.segments.first?.packetBlocks.first as? PcapngSpb else {
                XCTFail()
                return
            }
            XCTAssert(packet0.packetData.count == 314)
            guard let packet1 = pcapng.segments.first?.packetBlocks[1] as? PcapngSpb else {
                XCTFail()
                return
            }
            XCTAssert(packet1.packetData.count == 315)
        }
    }

    func test013Be() {
        let path = directory + "test013.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 0)
            XCTAssert(pcapng.segments.first?.interfaceStatistics.count == 1)
        }
    }

    func test014Be() {
        let path = directory + "test014.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 3)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 0)
            XCTAssert(pcapng.segments.first?.interfaceStatistics.count == 3)
        }
    }

    func test015Be() {
        let path = directory + "test015.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 0)
            XCTAssert(pcapng.segments.first?.nameResolutions.count == 1)
            XCTAssert(pcapng.segments.first?.nameResolutions.first?.ipv4records[IPv4Address("10.1.2.3")!] == ["example.org"])

        }
    }

    func test016Be() {
        let path = directory + "test016.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
            XCTAssert(pcapng.segments.first?.nameResolutions.count == 3)
        }
    }

    func test017Be() {
        let path = directory + "test017.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 0)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 0)
            XCTAssert(pcapng.segments.first?.customBlocks.count == 4)
        XCTAssert(pcapng.segments.first?.customBlocks.first?.blockType == 0xbad)
        XCTAssert(pcapng.segments.first?.customBlocks.first?.enterpriseNumber == 32473)
        XCTAssert(pcapng.segments.first?.customBlocks[1].blockType == 0x40000bad)


        }
    }

    func test018Be() {
        let path = directory + "test018.pcapng"
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: URL(fileURLWithPath: path))
        }
        switch result {
        case .failure(let error):
            debugPrint(error)
            XCTFail()
            return
        case .success(let data):
            XCTAssert(data.count > 0)
            guard let pcapng = Pcapng(data: data) else {
                XCTFail()
                return
            }
            XCTAssert(pcapng.segments.count == 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
            XCTAssert(pcapng.segments.first?.customBlocks.count == 4)
        }
    }


    /*static var allTests = [
        ("testExample", testExample),
    ]*/
}
