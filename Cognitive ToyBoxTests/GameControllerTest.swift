//
//  GameControllerTest.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/27/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import XCTest
import Blicket

class GameControllerTest: XCTestCase {
  
  var gameController : GameController = GameController()
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    gameController = GameController()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
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
  
  func testStartNewSession () {
    for i in 0..<100 {
      gameController.startNewSession(updateTaskManager: false)
//      XCTAssert(gameController.getMainObj() != nil)
      XCTAssert(gameController.sameNameObject.name == gameController.getMainObj().name)
      XCTAssert(gameController.diffNameObject.name != gameController.getMainObj().name)
      
    }
    
  }
  
  func testGetObjPair () {
    for i in 0..<100 {
      gameController.startNewSession(updateTaskManager: false)
      var pair = gameController.getObjPair()
      XCTAssert((pair.0.id == gameController.sameNameObject.id && pair.1.id == gameController.diffNameObject.id)
        || (pair.1.id == gameController.sameNameObject.id && pair.0.id == gameController.diffNameObject.id))
    }
  }
  
  func testGetCorrectObj () {
    for i in 0..<100 {
      gameController.startNewSession(updateTaskManager: false)
      var correctObj = gameController.getCorrectObj()
      XCTAssert(correctObj.name == gameController.getMainObj().name)
    }
  }
  
  func testGetListWithSameName () {
    for i in 0..<100 {
    gameController.startNewSession(updateTaskManager: false)
      var list = gameController.getListWithSameName()
      for item in list {
        XCTAssert(item.name == gameController.getMainObj().name)
      }
    }
  }
  
//  func testFirstStage () {
//    gameController.categories = NSMutableSet(array: ["1", "2", "3", "4", "5"])
//    gameController.firstStage()
//    XCTAssert(gameController.searchRange.endIndex == 5)
//    for i in 0..<5 {
//      XCTAssert(gameController.searchCategories.containsObject("\(i+1)"))
//    }
//  }
//  
//  func testNextStage () {
//    gameController.categories = NSMutableSet(array: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
//    gameController.firstStage()
//    gameController.nextStage()
//    XCTAssert(gameController.searchRange.endIndex == 10)
////    for i in 0..5 {
////      XCTAssert(!gameController.searchCategories.containsObject("\(i)"))
////    }
//    
//    for i in 0..<10 {
//      XCTAssert(gameController.searchCategories.containsObject("\(i)"))
//    }
//    
//    gameController.nextStage()
//    for i in 0..<10 {
//      XCTAssert(gameController.searchCategories.containsObject("\(i)"))
//    }
//  }
  
}
