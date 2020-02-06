import XCTest
import Network
@testable import PackageSwiftPcapng

final class PackageSwiftPcapngDifficultLeTests: XCTestCase {
    // For testing get files from https://github.com/hadrielk/pcapng-test-generator
    // and point the test suite at it
    let directory = "/Users/droot/Dropbox/programming/projects-github/pcapng-test-generator/output_le/difficult/"
    func test200Le() {
        let path = directory + "test200.pcapng"
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
            XCTAssert(pcapng.segments.count == 3)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 0)
            //XCTAssert(pcapng.segments.first?.interfaces.first?.options.count == 2)
        }
    }
    
    func test201Le() {
        let path = directory + "test201.pcapng"
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
            XCTAssert(pcapng.segments.count == 3)
            XCTAssert(pcapng.segments.first?.interfaces.count == 2)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 1)
            
        }
    }
    
    func test202Le() {
        let path = directory + "test202.pcapng"
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
            XCTAssert(pcapng.segments.count == 3)
            XCTAssert(pcapng.segments.first?.interfaces.count == 2)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 3)
            //XCTAssert(pcapng.segments.first?.options[0].description == "hardware Apple MBP")
        }
    }


/*static var allTests = [
 ("testExample", testExample),
 ]*/
}
