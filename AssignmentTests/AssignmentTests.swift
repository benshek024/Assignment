//
//  AssignmentTests.swift
//  AssignmentTests
//
//  Created by Ben Shek on 4/1/2022.
//

import XCTest
@testable import Assignment

class AssignmentTests: XCTestCase {

    var sut: ViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

}
