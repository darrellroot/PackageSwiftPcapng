import XCTest
import Network
@testable import PackageSwiftPcapng

final class PackageSwiftPcapngAdvancedBeTests: XCTestCase {
    // For testing get files from https://github.com/hadrielk/pcapng-test-generator
    // and point the test suite at it
    let directory = "/Users/droot/Dropbox/programming/projects-github/pcapng-test-generator/output_be/advanced/"
    func test100Be() {
        let path = directory + "test100.pcapng"
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
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 5)
            XCTAssert(pcapng.segments.first?.nameResolutions.count == 5)
        }
    }
    
    func test101Be() {
        let path = directory + "test101.pcapng"
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
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 4)
            XCTAssert(pcapng.segments.first?.interfaceStatistics.count == 6)
        }
    }
    
    func test102Be() {
        let path = directory + "test102.pcapng"
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
