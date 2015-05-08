//
//  UserPerformanceHelperTest.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/30/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import XCTest
import Blicket

class UserPerformanceHelperTest: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UserPerformanceHelper.clear()
    UserPerformanceHelper.update(name: "apple", correct: true)
    UserPerformanceHelper.update(name: "banana", correct: false)
    UserPerformanceHelper.update(name: "banana")
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    UserPerformanceHelper.clear()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    XCTAssert(true, "Pass")
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock() {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testGetPerformance () {
    let performance : [String: PerformanceData] = UserPerformanceHelper.getPerformance()
    XCTAssert(performance["apple"]!.accuracy==1.0 && performance["banana"]!.accuracy==0.5)
    XCTAssert(performance["apple"]!.total == 1)
    XCTAssert(performance["apple"]!.correct == 1)
    XCTAssert(performance["banana"]!.total == 2)
    XCTAssert(performance["banana"]!.correct == 1)
  }
  
  // don't test it when your system date is changing soon!
  func testGetFirstViewedNames () {
    let now = NSDate(timeIntervalSinceNow: 0)
    let dateBounds = DateHelper.getDayBoundary(now)
    let firstViewedNames = UserPerformanceHelper.getFirstViewedNames(dateFrom: dateBounds.0, dateTo: dateBounds.1)
    XCTAssert(firstViewedNames.count == 2)
  }

}
