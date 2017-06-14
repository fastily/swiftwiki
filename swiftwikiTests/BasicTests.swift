import XCTest
@testable import swiftwiki

/**
 Basic (non-admin) query tests
 - author: Fastily
*/
class BasicTests: XCTestCase
{
    /**
     The wiki object we'll be using
    */
    fileprivate static var wiki : Wiki? = nil
    
    /**
     Intializes global Wiki object for BasicTests
    */
    override class func setUp()
    {
        //Settings.debug = true
        do
        {
            let upx = try String(contentsOfFile: ("~/Documents/.a.txt" as NSString).expandingTildeInPath, encoding: String.Encoding.utf8).components(separatedBy: ":")
            wiki = Wiki(upx[0], px: upx[1], domain: "test.wikipedia.org")
            
            print("TOKEN IS -----> \(wiki!.token)")
        }
        catch //everything
        {
            XCTFail("Login failed - cannot continue, so program will exit")
            exit(1)
        }
    }
    
    
    func testNothing()
    {
        print("hi")
    }
}
