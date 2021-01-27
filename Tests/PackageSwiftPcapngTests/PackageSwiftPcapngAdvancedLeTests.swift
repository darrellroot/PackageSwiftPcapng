import XCTest
import Network
@testable import PackageSwiftPcapng

final class PackageSwiftPcapngAdvancedLeTests: XCTestCase {
    func getPcapngURL(forResource basename: String, withExtension ext: String) -> URL {
      return Bundle.module.url(
        forResource: basename, 
        withExtension: ext,
        subdirectory: "Resources/output_le/advanced"
      )!
    }

    func test100Le() {
        let pcapngURL = getPcapngURL(forResource: "test100", withExtension: "pcapng")
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
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 5)
            XCTAssert(pcapng.segments.first?.nameResolutions.count == 5)
        }
    }
    
    func test101Le() {
        let pcapngURL = getPcapngURL(forResource: "test101", withExtension: "pcapng")
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
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
            XCTAssert(pcapng.segments.first?.interfaceStatistics.count == 6)
        }
    }
    
    func test102Le() {
        let pcapngURL = getPcapngURL(forResource: "test102", withExtension: "pcapng")
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
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 5)
            XCTAssert(pcapng.segments.first?.customBlocks.count == 3)
            XCTAssert(pcapng.segments.first?.interfaceStatistics.count == 6)
            XCTAssert(pcapng.segments.first?.nameResolutions.count == 3)
            //XCTAssert(pcapng.segments.first?.options[0].description == "hardware Apple MBP")
        }
    }


/*static var allTests = [
 ("testExample", testExample),
 ]*/
}
