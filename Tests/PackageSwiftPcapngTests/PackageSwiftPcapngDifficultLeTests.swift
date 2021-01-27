import XCTest
import Network
@testable import PackageSwiftPcapng

final class PackageSwiftPcapngDifficultLeTests: XCTestCase {
    func getPcapngURL(forResource basename: String, withExtension ext: String) -> URL {
      return Bundle.module.url(
        forResource: basename, 
        withExtension: ext,
        subdirectory: "Resources/output_le/difficult"
      )!
    }

    func test200Le() {
        let pcapngURL = getPcapngURL(forResource: "test200", withExtension: "pcapng")
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
            XCTAssert(pcapng.segments.count == 3)
            XCTAssert(pcapng.segments.first?.interfaces.count == 1)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 0)
            //XCTAssert(pcapng.segments.first?.interfaces.first?.options.count == 2)
        }
    }
    
    func test201Le() {
        let pcapngURL = getPcapngURL(forResource: "test201", withExtension: "pcapng")
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
            XCTAssert(pcapng.segments.count == 3)
            XCTAssert(pcapng.segments.first?.interfaces.count == 2)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 1)
            
        }
    }
    
    //opened an issue with https://github.com/hadrielk/pcapng-test-generator/issues/1
    //I think the test file is invalid
/*    func test202Le() {
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
            XCTAssert(pcapng.segments.count > 1)
            XCTAssert(pcapng.segments.first?.interfaces.count == 2)
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 3)
            XCTAssert(pcapng.segments[safe: 1]?.interfaces.count == 1)
            XCTAssert(pcapng.segments[safe: 1]?.packetBlocks.count == 4)
            XCTAssert(pcapng.segments[safe: 1]?.nameResolutions.count == 2)
            XCTAssert(pcapng.segments[safe: 1]?.customBlocks.count == 1)
            XCTAssert(pcapng.segments[safe: 2]?.nameResolutions.count == 1)
            XCTAssert(pcapng.segments[safe: 2]?.interfaces.count == 3)

            //XCTAssert(pcapng.segments.first?.options[0].description == "hardware Apple MBP")
        }
    }*/


/*static var allTests = [
 ("testExample", testExample),
 ]*/
}
