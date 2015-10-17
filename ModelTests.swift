//
//  ModelTests.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/17/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import XCTest

class AppDelegateTests: XCTestCase {
    
    var utilities: Utilities?
    var network: Network?
    
    override func setUp() {
        super.setUp()
        utilities = Utilities()
        network = Network()
    }
    
    func testInitializationOfClassLevelObjects() {
        XCTAssertFalse((utilities == nil), "Shared Instance of Utilities() failed to initialize")
        XCTAssertFalse((network == nil), "Shared Instance of Network() failed to initialize")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
