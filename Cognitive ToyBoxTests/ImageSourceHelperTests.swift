//
//  ImageSourceHelperTests.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/20/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import XCTest
import Cognitive_ToyBox

class ImageSourceHelperTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
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
  
//  func testListFileAtPath_count () {
//    let directoryContent = ImageSourceHelper.listFileAtPath(path: NSString(string: "/Users/henglyu/Documents/Test"))
//    XCTAssert(1 == directoryContent.count)
//  }
  
//  func testListImgFiles_count () {
//    let directoryContent = ImageSourceHelper.listFilesWithImageExt()
//    XCTAssert(44 == directoryContent.count)
//  }
  
//  func testGetFileName () {
//    let fileName = ImageSourceHelper.getFileName(path: "/User/Documents/Steve Jobs.jpg")
//    XCTAssert("Steve Jobs" == fileName)
//  }
  
//  func testGetObjFromDir () {
//    var objects = ImageSourceHelper.getObjFromDir()
//    var name = objects[0].name
//    var material = objects[0].material
//    var color = objects[0].color
//    var count = objects.count
//    XCTAssert(objects[0].name=="spoon")
//    XCTAssert(objects[0].material=="wood")
//    XCTAssert(objects[0].color==nil)
//    XCTAssert(objects.count == 50)
//  }
  
  func testObjectFileMatch () {
    XCTAssert(ImageSourceHelper.objectFileMatch("apple_x_green"))
    XCTAssert(ImageSourceHelper.objectFileMatch("apple_x_green_leaf"))
    XCTAssert(!ImageSourceHelper.objectFileMatch("apple_x_green.jpg"))
    XCTAssert(!ImageSourceHelper.objectFileMatch("x.jpg"))
    XCTAssert(!ImageSourceHelper.objectFileMatch(""))
    XCTAssert(!ImageSourceHelper.objectFileMatch("_apple_x_green"))
    XCTAssert(!ImageSourceHelper.objectFileMatch("apple_x_green_"))
    XCTAssert(!ImageSourceHelper.objectFileMatch("apple_x__green"))
    XCTAssert(!ImageSourceHelper.objectFileMatch("appl e_x _green"))



  }
  
}
