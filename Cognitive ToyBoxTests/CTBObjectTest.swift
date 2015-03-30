//
//  CTBObjectTest.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/25/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import XCTest
import Cognitive_ToyBox
import UIKit
import CoreData

class CTBObjectTest: XCTestCase {
  
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
  
//  func testCopyFrom_noMaterial () {
//    var from = CognitiveToyBoxObject()
//    var to   = CognitiveToyBoxObject()
//    
//    from.id = 10
//    from.name = "banana"
//    from.material = nil
//    from.color = "yellow"
//    
//    to.copyFrom(from)
//    
//    XCTAssert(from.id == to.id)
//    XCTAssert(from.name == to.name)
//    XCTAssert(from.material == to.material)
//    XCTAssert(from.color == to.color)
//  }
//  
//  func testCopyFrom_hasMaterial () {
//    var from = CognitiveToyBoxObject()
//    var to   = CognitiveToyBoxObject()
//    
//    from.id = 10
//    from.name = "banana"
//    from.material = "fruit"
//    from.color = "yellow"
//    
//    to.copyFrom(from)
//    
//    XCTAssert(from.id == to.id)
//    XCTAssert(from.name == to.name)
//    XCTAssert(from.material == to.material)
//    XCTAssert(from.color == to.color)
//  }
  
//  func testInit () {
//    var ctbObj = CognitiveToyBoxObject()
//    XCTAssert(ctbObj.name == "")
//    XCTAssert(ctbObj.material == nil)
//    XCTAssert(ctbObj.color == "")
//    
//    ctbObj = CognitiveToyBoxObject(name: "apple", material: CognitiveToyBoxObject.unknownMaterial(), color: "red")
//    XCTAssert(ctbObj.getName() == "apple")
//    XCTAssert(ctbObj.getMaterial() == nil)
//    XCTAssert(ctbObj.getColor() == "red")
//    
//    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//    var context:NSManagedObjectContext = appDelegate.managedObjectContext
//    
//    var error : NSErrorPointer = nil
//    var request = NSFetchRequest(entityName: "CTBObject")
//    request.returnsObjectsAsFaults = false
//    
//    var predicate = NSPredicate(format: "name = %@ && material = %@ && color = %@", "apple", nil, "green")
//    request.predicate = predicate
//    
//    var results = context.executeFetchRequest(request, error: error) as NSArray
//    var first = results.firstObject as NSManagedObject
//    
//    ctbObj = CognitiveToyBoxObject(nsmObject: first)
//    XCTAssert(ctbObj.getName() == "apple")
//    XCTAssert(ctbObj.getMaterial() == nil)
//    XCTAssert(ctbObj.getColor() == "green")
//  }
  
  func testBuilder () {
    let name = "apple"
    let material = CognitiveToyBoxObject.unknownMaterial
    let color = CognitiveToyBoxObject.unknownColor
    
    var builder = CognitiveToyBoxObjectBuilder()
    builder.id = 0
    builder.name = name
    builder.material = material
    builder.color = color
    
    var ctbObj = builder.build()
    XCTAssert(ctbObj.name == name)
    XCTAssert(ctbObj.material == nil)
    XCTAssert(ctbObj.color == nil)
    
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var context:NSManagedObjectContext = appDelegate.managedObjectContext!
    
    var error : NSErrorPointer = nil
    var request = NSFetchRequest(entityName: "CTBObject")
    request.returnsObjectsAsFaults = false
    
    var predicate = NSPredicate(format: "name = %@ && material = nil && color = %@", "apple", "green")
    request.predicate = predicate
    
    var results = context.executeFetchRequest(request, error: error)! as NSArray
    var first = results.firstObject as NSManagedObject
    
    ctbObj = CognitiveToyBoxObjectBuilder().buildFromNSManagedObject(first)
    XCTAssert(ctbObj.name == "apple")
    XCTAssert(ctbObj.material == nil)
    XCTAssert(ctbObj.color == "green")
  }
  
  func testToString () {
    let name = "apple"
    let material = CognitiveToyBoxObject.unknownMaterial
    let color = CognitiveToyBoxObject.unknownColor
    
    var builder = CognitiveToyBoxObjectBuilder()
    builder.id = 0
    builder.name = name
    builder.material = material
    builder.color = color
    
    var ctbObj = builder.build()
    println(ctbObj)
    XCTAssert(ctbObj.description == "\(name)_\(CognitiveToyBoxObject.unknownMaterial)_\(CognitiveToyBoxObject.unknownColor)")
  }
//  
//  func testGetter () {
//    var id = 10
//    var name = "apple"
//    var material = CognitiveToyBoxObject.unknownMaterial()
//    var color = "red"
//    
//    var ctbObj = CognitiveToyBoxObject()
////    ctbObj = CognitiveToyBoxObject(name: "apple", material: ctbObj.unknownMaterial, color: "red")
//    ctbObj.setId(id)
//    ctbObj.setName(name)
//    ctbObj.setMaterial(material)
//    ctbObj.setColor(color)
//    
//    XCTAssert(ctbObj.getId() == id)
//    XCTAssert(ctbObj.getName() == name)
//    XCTAssert(ctbObj.getMaterial() == nil)
//    XCTAssert(ctbObj.getColor() == color)
//  }
  
}
