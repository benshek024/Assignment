//
//  AssignmentTests.swift
//  AssignmentTests
//
//  Created by Ben Shek on 4/1/2022.
//

import XCTest
import UIKit
import MapKit

@testable import Assignment

class AssignmentTests: XCTestCase {

    var vcUnderTest: ViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        vcUnderTest = storyboard.instantiateViewController(identifier: "main_vc") as ViewController
        
        if (vcUnderTest != nil) {
            vcUnderTest.loadView()
            vcUnderTest.viewDidLoad()
        }
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        vcUnderTest = ViewController()
    }

    override func tearDownWithError() throws {
        vcUnderTest = nil
        try super.tearDownWithError()
    }
    
    func testUserLocation() {
        XCTAssertTrue(vcUnderTest.locationManager.location?.coordinate.latitude == 22.502192)
        XCTAssertTrue(vcUnderTest.locationManager.location?.coordinate.longitude == 114.134865)
    }
    
}
