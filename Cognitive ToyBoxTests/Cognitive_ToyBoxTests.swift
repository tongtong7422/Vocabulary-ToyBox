////
////  Cognitive_ToyBoxTests.swift
////  Cognitive ToyBoxTests
////
////  Created by Heng Lyu on 6/19/14.
////  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
////
//
//import XCTest
//import UIKit
//import Blicket
//import CoreData
//
//class Cognitive_ToyBoxTests: XCTestCase {
//    
//    var gvc: GameViewController! = nil
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        gvc = GameViewController()
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testExample() {
//        // This is an example of a functional test case.
//        XCTAssert(true, "Pass")
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
//    
//    func testRefreshCoreData () {
//        var objects = ImageSourceHelper.getObjFromDir()
//        GlobalConfiguration.refreshCoreData()
//        
//        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        var context:NSManagedObjectContext = appDelegate.managedObjectContext!
//        
//        NSLog("Clearing Core Data...")
//        var request = NSFetchRequest(entityName: "CTBObject")
//        request.returnsObjectsAsFaults = false
//        request.includesPropertyValues = false
//        
//        var error : NSErrorPointer = nil
//        var saveError : NSErrorPointer = nil
//        var results : NSArray = context.executeFetchRequest(request, error: error)!
//        
//        XCTAssert(objects.count == results.count)
//    }
//    
//}
