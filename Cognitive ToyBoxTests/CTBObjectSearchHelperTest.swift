////
////  CTBObjectSearchHelperTest.swift
////  Cognitive ToyBox
////
////  Created by Heng Lyu on 6/25/14.
////  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
////
//
//import XCTest
//import Blicket
//
//class CTBObjectSearchHelperTest: XCTestCase {
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
//  func testGetRandomObject_emptyId () {
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getRandomObject()
//      if obj != nil {
//        NSLog("Fetched object: \(obj!)")
//      }
//      else {
//        XCTFail("Cannot fetch object")
//      }
//    }
//    XCTAssert(true)
//  }
//  
//  func testGetRandomObject_setId () {
//    var exceptId = 0
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getRandomObject(exceptId: exceptId)
//      
//      if obj != nil {
//        XCTAssert(obj!.id != exceptId)
//      }
//      else {
//        XCTFail("Cannot fetch object")
//      }
//    }
//  }
//  
//  func testGetRandomObject_forNames () {
//    var forNames = NSSet(array: ["apple", "bowl"])
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getRandomObject(forNames: forNames)
//      
//      if obj != nil {
//        XCTAssert(forNames.containsObject(obj!.name))
//      }
//      else {
//        XCTFail("Cannot fetch object")
//      }
//    }
//  }
//  
//  func testGetSameNameObject_emptyId () {
//    var name = "apple"
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getSameNameObject(name: name)
//      if obj != nil {
//        XCTAssert(obj!.name == name)
//      }
//      else {
//        XCTFail("Cannot fetch object")
//      }
//    }
//  }
//  
//  func testGetSameNameObject_setId () {
//    var exceptId = 0
//    var name = "apple"
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getSameNameObject(name: name, exceptId: exceptId)
//      if obj != nil {
//        XCTAssert(obj!.id != exceptId && obj!.name == name)
//      }
//      else {
//        XCTFail("Cannot fetch object")
//      }
//    }
//  }
//  
//  func testGetDiffNameObject_noParam () {
//    var name = "apple"
//    var material : String? = nil
//    var color : String? = nil
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getDiffNameObject(name: name, material: material, color: color)
////      if obj != nil {
////        XCTAssert(obj!.name != name)
////      }
////      else {
////        XCTFail("Cannot fetch object")
////      }
//      
////      XCTAssert(obj == nil)
//    }
//  }
//  
//  func testGetDiffNameObject_noMaterial () {
//    var name = "apple"
//    var material : String? = nil
//    var color = "green"
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getDiffNameObject(name: name, material: material, color: color)
//      if obj != nil {
//        XCTAssert(obj!.name != name && obj!.color == color)
//      }
//      else {
//        XCTFail("Cannot fetch object")
//      }
//    }
//  }
//  
//  func testGetDiffNameObject_noColor () {
//    var name = "bowl"
//    var material = "steel"
//    var color : String? = nil
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getDiffNameObject(name: name, material: material, color: color)
//      if obj != nil {
//        XCTAssert(obj!.name != name && (obj!.material == material))
//      }
//      else {
//        XCTFail("Cannot fetch object")
//      }
//    }
//  }

//  func testGetDiffNameObject_fullParam () {
//    var name = "bowl"
//    var material : String? = "metal"
//    var color = "silver"
//    for i in 1..100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getDiffNameObject(name: name, material: material, color: color)
//      if obj != nil {
//        XCTAssert(obj!.name != name && (obj!.color == color || obj!.material == material))
//      }
//      else {
//        XCTFail("Cannot fetch object")
//      }
//    }
//  }
  
//  func testGetDiffNameObjectOnMaterial_noMaterial () {
//    var name = "apple"
//    var material : String? = nil
//    var color = "green"
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnMaterial(name: name, material: material)
//      XCTAssert(obj == nil)
//    }
//  }
  
//  func testGetDiffNameObjectOnMaterial_hasMaterial () {
//    var name = "bowl"
//    var material : String? = "steel"
//    var color : String? = nil
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnMaterial(name: name, material: material)
//      if obj != nil {
//        XCTAssert(obj!.name != name && (obj!.material == material))
//      }
//      else {
//        XCTFail("Cannot fetch object")
//      }
//    }
//  }
  
//  func testGetDiffNameObjectOnColor_noColor () {
//    var name = "bowl"
//    var material : String? = "metal"
//    var color : String? = nil
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnColor(name: name, color: color)
//      XCTAssert(obj == nil)
//    }
//  }
//  
//  func testGetDiffNameObjectOnColor_hasColor () {
//    var name = "apple"
//    var material : String? = nil
//    var color = "green"
//    for i in 1..<100 {
//      var obj = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnColor(name: name, color: color)
//      if obj != nil {
//        XCTAssert(obj!.name != name && (obj!.color == color))
//      }
//      else {
//        XCTFail("Cannot fetch object")
//      }
//    }
//  }
//
//  
//  func testGetSameNameAll_noLimit () {
//    var name = "apple"
//    var objList = CognitiveToyBoxObjectSearchHelper.getSameNameAll(name: name)
//    for obj : CognitiveToyBoxObject in objList {
//      XCTAssert(obj.name==name)
//    }
//  }
//  
//  func testGetSameNameAll_withLimit () {
//    var name = "apple"
//    var limit = 1
//    var objList = CognitiveToyBoxObjectSearchHelper.getSameNameAll(name: name, limit: limit)
//    for obj : CognitiveToyBoxObject in objList {
//      XCTAssert(obj.name==name)
//    }
//    XCTAssert(objList.count <= limit)
//  }
//  
//}
