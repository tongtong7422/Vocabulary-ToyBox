////
////  DateHelperTest.swift
////  Cognitive ToyBox
////
////  Created by Heng Lyu on 7/24/14.
////  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
////
//
//import XCTest
//import Blicket
//
//class DateHelperTest: XCTestCase {
//  
//  override func setUp() {
//    super.setUp()
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//  }
//  
//  override func tearDown() {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    super.tearDown()
//  }
//  
//  func testExample() {
//    // This is an example of a functional test case.
//    XCTAssert(true, "Pass")
//  }
//  
//  func testPerformanceExample() {
//    // This is an example of a performance test case.
//    self.measureBlock() {
//      // Put the code you want to measure the time of here.
//    }
//  }
//  
//  func testGetDatesInPastDays () {
//    var days = 7
//    var date = NSDate(timeIntervalSinceNow: 0)
//    var dates = DateHelper.getDatesInPastDays(date, days: days)
//    var calendar = NSCalendar.currentCalendar()
//    var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
//    let day = components.day
//    
//    for dayOffset in 0..<days {
////      components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: dates[dayOffset])
//      components = calendar.components(.CalendarUnitDay, fromDate: dates[dayOffset], toDate: date, options: nil)
//      XCTAssert(components.day == days - dayOffset - 1)
//      
//    }
//  }
//  
//  func testgetDaysInWeek () {
//    var calendar = NSCalendar.currentCalendar()
//    var components : NSDateComponents
//    
//    var date = NSDate(timeIntervalSinceNow: 0)
//    var daysInWeek = DateHelper.getDaysInWeek(date)
//    
//    for i in 0..<daysInWeek.count {
//      components = calendar.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: daysInWeek[i])
//      XCTAssert(components.weekday == i+1)
//    }
//    
//  }
//  
//  func testGetDayBoundary () {
//    var date = NSDate(timeIntervalSinceNow: 0)
//    var boundary = DateHelper.getDayBoundary(date)
//    var calendar = NSCalendar.currentCalendar()
//    var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
//    var componentsEarly = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour, fromDate: boundary.0)
//    var componentsLate  = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour, fromDate: boundary.1)
//    
//    XCTAssert(components.day == componentsEarly.day)
//    XCTAssert(components.day+1 == componentsLate.day)
//    XCTAssert(componentsEarly.hour == 0)
//    XCTAssert(componentsLate.hour == 0)
//  }
//  
//  func testGetSomeDaysEarlier () {
//    var calendar = NSCalendar.currentCalendar()
//    var now = NSDate(timeIntervalSinceNow: 0)
//    var date = DateHelper.getSomeDaysEarlier (now, days: 1)
//    var components = calendar.components(NSCalendarUnit.CalendarUnitDay, fromDate: date, toDate: now, options: nil)
//    XCTAssert(components.day == 1)
//  }
//  
//}
