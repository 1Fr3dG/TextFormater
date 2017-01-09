#if os(iOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif
import XCTest
import TextFormater

class Tests: XCTestCase {
    
    var tester = TextFormater()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        tester = TextFormater()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFormatWithBlankString() {
        let result = tester.format("")
        
        XCTAssertEqual(0, result?.length)
    }
    
    func testAddFont() {
        let _font = UIFont.boldSystemFont(ofSize: 123)
        XCTAssertNil(tester.fonts["testf1"])
        
        tester.setFont(name: "testf1", font: _font)
        XCTAssertEqual(_font.fontName, tester.fonts["testf1"])
    }
    
    func testAddColor() {
        let _color = UIColor.init(red: 0.1, green: 0.2, blue: 0.3, alpha: 0.4)
        XCTAssertNil(tester.colors["testc1"])
        
        tester.setColor(name: "testc1", color: _color)
        XCTAssertEqual(_color, tester.colors["testc1"])
    }
    
}
