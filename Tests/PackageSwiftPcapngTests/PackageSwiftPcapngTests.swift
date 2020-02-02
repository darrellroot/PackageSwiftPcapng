import XCTest
@testable import PackageSwiftPcapng

final class PackageSwiftPcapngTests: XCTestCase {
    func testExample() {
        let path = "/Users/droot/Dropbox/programming/projects-github/pcapng-test-generator/output_le/basic/test001.pcapng"
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail()
            return
        }
        XCTAssert(data.count > 0)
        guard let pcapng = Pcapng(data: data) else {
            XCTFail()
            return
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
