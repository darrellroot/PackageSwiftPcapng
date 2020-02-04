import XCTest
@testable import PackageSwiftPcapng

final class PackageSwiftPcapngBasicLeTests: XCTestCase {
    // For testing get files from https://github.com/hadrielk/pcapng-test-generator
    // and point the test suite at it
    let directory = "/Users/droot/Dropbox/programming/projects-github/pcapng-test-generator/output_le/basic/"
    func test001Le() {
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
            debugPrint(pcapng)
        }
    }
    
    func test002Le() {
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
            debugPrint(pcapng)
        }
    }

    func test003Le() {
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
            debugPrint(pcapng)
        }
    }
    
    func test004Le() {
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
            debugPrint(pcapng)
        }
    }



    /*static var allTests = [
        ("testExample", testExample),
    ]*/
}
