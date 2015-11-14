import XCTest
@testable import swiftwiki

class BasicTests: XCTestCase {
    
    /*
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }*/
    
    /*
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }*/
    
    func testLogin() {
        
        Settings.debug = true
        
        do
        {
            let upx = try String(contentsOfFile: ("~/Documents/.a.txt" as NSString).stringByExpandingTildeInPath, encoding: NSUTF8StringEncoding).componentsSeparatedByString(":")
        
            let wiki = Wiki(upx[0], px: upx[1], domain: "test.wikipedia.org")
            
            print("TOKEN IS -----> \(wiki.token)")
        }
        catch //everything
        {
            XCTFail("Login failed - cannot continue, so program will exit")
            exit(1)
        }
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }*/
    
}
