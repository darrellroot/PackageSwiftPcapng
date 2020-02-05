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

    func test005Le() {
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
            debugPrint(pcapng)
        }
    }

    func test006Le() {
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
            debugPrint(pcapng)
        }
    }

    func test007Le() {
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
            debugPrint(pcapng)
        }
    }


    func test008Le() {
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
            debugPrint(pcapng)
        }
    }

    func test009Le() {
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
            debugPrint(pcapng)
        }
    }
    
    func test010Le() {
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
            debugPrint(pcapng)
        }
    }

    func test011Le() {
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
            debugPrint(pcapng)
        }
    }

    func test012Le() {
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
            debugPrint(pcapng)
        }
    }

    func test013Le() {
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
            debugPrint(pcapng)
        }
    }

    func test014Le() {
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
            debugPrint(pcapng)
        }
    }

    func test015Le() {
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
            //TODO NRB = 1
            debugPrint(pcapng)
        }
    }

    func test016Le() {
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
            XCTAssert(pcapng.segments.first?.packetBlocks.count == 3)
            //TODO NRB = 3
            debugPrint(pcapng)
        }
    }

    func test017Le() {
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
            //TODO CB = 2, DCB = 2
            debugPrint(pcapng)
        }
    }

    func test018Le() {
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
            //TODO CB=2 DCB=2
            debugPrint(pcapng)
        }
    }


    /*static var allTests = [
        ("testExample", testExample),
    ]*/
}
