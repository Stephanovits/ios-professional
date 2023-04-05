//
//  CurrencyFormatterTests.swift
//  BankeyUnitTests
//
//  Created by Stephan Schranz on 13/04/2023.
//

import Foundation
import  XCTest

//this makes all classes of Bankey available to us so we can test them
@testable import Bankey

class Test: XCTestCase {
    //force unwrapping saying the that 'formatter' will be available once we start testing because we will set it up
    var formatter: CurrencyFormatter!
    
    //this gets run after every test
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }
    
    func testBreakDollarsIntoCents() throws {
        let result = formatter.breakIntoDollarsAndCents(929466.23)
        XCTAssertEqual(result.0, "929,466")
        XCTAssertEqual(result.1, "23")
    }
    
    func testDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(932199)
        XCTAssertEqual("$932,199.00", result)
    }
    
    func testZeroDollarsformatted() throws {
        let result = formatter.dollarsFormatted(0)
        XCTAssertEqual("$0.00", result)
    }
    
}
