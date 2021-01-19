import XCTest
import Network
@testable import PackageSwiftPcapng

final class PackageSwiftPcapngBasicLeTests: XCTestCase {
    func getPcapngURL(forResource basename: String, withExtension ext: String) -> URL {
      return Bundle.module.url(
        forResource: basename, 
        withExtension: ext,
        subdirectory: "Resources/output_le/basic"
      )!
    }

    // NOTE: Not sure where the cap1.pcapng file lives.
    // func testTime() {
    //     let path = directory + "cap1.pcapng"
    //         let result: Result<Data,Error> = Result {
    //             try Data(contentsOf: URL(fileURLWithPath: path))
    //         }
    //         switch result {
    //         case .failure(let error):
    //             debugPrint(error)
    //             XCTFail()
    //             return
    //         case .success(let data):
    //             XCTAssert(data.count > 0)
    //             guard let pcapng = Pcapng(data: data) else {
    //                 XCTFail()
    //                 return
    //             }
    //             XCTAssert(pcapng.segments.count == 1)
    //             XCTAssert(pcapng.segments.first?.interfaces.count == 1)
    //             XCTAssert(pcapng.segments.first?.packetBlocks.count == 7)
                
    //         }
    //     }
    func test001Le() {
        let pcapngURL = getPcapngURL(forResource: "test001", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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
    
    func test002Le() {
        let pcapngURL = getPcapngURL(forResource: "test002", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test003Le() {
        let pcapngURL = getPcapngURL(forResource: "test003", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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
    
    func test004Le() {
        let pcapngURL = getPcapngURL(forResource: "test004", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test005Le() {
        let pcapngURL = getPcapngURL(forResource: "test005", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test006Le() {
        let pcapngURL = getPcapngURL(forResource: "test006", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test007Le() {
        let pcapngURL = getPcapngURL(forResource: "test007", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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


    func test008Le() {
        let pcapngURL = getPcapngURL(forResource: "test008", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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
            XCTAssert(pcapng.segments.first?.interfaces[1].options[2].description == "custom19372 enterprise 543517537 data 10 bytes")
            XCTAssert(pcapng.segments.first?.interfaces[0].options[4].description == "ipv6 2100:db8::1a2b/64")

        }
    }

    func test009Le() {
        let pcapngURL = getPcapngURL(forResource: "test009", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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
    
    func test010Le() {
        let pcapngURL = getPcapngURL(forResource: "test010", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test011Le() {
        let pcapngURL = getPcapngURL(forResource: "test011", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test012Le() {
        let pcapngURL = getPcapngURL(forResource: "test012", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test013Le() {
        let pcapngURL = getPcapngURL(forResource: "test013", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test014Le() {
        let pcapngURL = getPcapngURL(forResource: "test014", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test015Le() {
        let pcapngURL = getPcapngURL(forResource: "test015", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test016Le() {
        let pcapngURL = getPcapngURL(forResource: "test016", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test017Le() {
        let pcapngURL = getPcapngURL(forResource: "test017", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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

    func test018Le() {
        let pcapngURL = getPcapngURL(forResource: "test018", withExtension: "pcapng")
        let result: Result<Data,Error> = Result {
            try Data(contentsOf: pcapngURL)
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
