//
//  CTBObjectHelper.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/24/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import CoreData

extension Array
  {
  /* Randomizes the order of an array's elements. */
  mutating func shuffle()
  {
    for _ in 0..<10
    {
      sort { (_,_) in arc4random() < arc4random() }
    }
  }
  
}

/*

CognitiveToyBoxObjectSearchHelper accesses Core Data. The following methods are provided:

class func getRandomObject (exceptId:Int=-1) -> CognitiveToyBoxObject
return a random picked object different from given id

class func getSameNameObject (#name:String, exceptId:Int = -1) -> CognitiveToyBoxObject
return a random picked object where name=name, id!=exceptId

class func getDiffNameObject (#name:String, material:String, color:String) -> CognitiveToyBoxObject
return a random picked object where name!=name, material=material or color=color

class func getSameNameAll (#name:String, limit:Int = -1) -> CognitiveToyBoxObject[]
return all objects where name = name. limit = -1 stands for no limit

*/
public class CognitiveToyBoxObjectSearchHelper {
  
  /* return a random picked object different from given id */
  public class func getRandomObject (exceptId:Int = -1, forNames:NSSet? = nil, entityName:String = "CTBObject") -> CognitiveToyBoxObject? {
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var context:NSManagedObjectContext = appDelegate.managedObjectContext
    
    NSLog("Getting random object...")
    var request = NSFetchRequest(entityName: entityName)
    request.returnsObjectsAsFaults = false
    
    var predicate = NSPredicate(format: "id != %d", exceptId)
    
    /* specify object for debug purpose */
//    predicate = NSPredicate(format: "name = %@ && suffix = nil", "plate")

    request.predicate = predicate
    
    var error : NSErrorPointer = nil
//    var results = context.executeFetchRequest(request, error: error) as! [NSManagedObject]
    var results:[NSManagedObject]!
    do {
      results = try context.executeFetchRequest(request) as! [NSManagedObject]
    }catch let error as NSError{
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error fetching random object")
    }

    
//    ErrorLogger.logError(error, message: "Error fetching random object")
    
    
    
    
    if forNames != nil {
      results = results.filter() {
        includeElement in
        forNames!.containsObject(includeElement.valueForKey("name")!)
      }
    }
    
    if results.count <= 0 {
      NSLog("Done fetching nil.")
      return nil
    }
    
    
    
    let nsmObject = results[Int(arc4random_uniform(UInt32(results.count)))] as NSManagedObject
    var ctbObject = CognitiveToyBoxObjectBuilder().buildFromNSManagedObject(nsmObject)
    
    NSLog("Done fetching \(ctbObject).")
    return ctbObject
    
  }
  
  /* return a random picked object where name=name, id!=exceptId */
//  public class func getSameNameObjectList (#name:String, exceptId:Int = -1) -> [CognitiveToyBoxObject] {
//    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    var context:NSManagedObjectContext = appDelegate.managedObjectContext!
//    
//    NSLog("Getting same name object list...")
//    var error : NSErrorPointer = nil
//    var request = NSFetchRequest(entityName: "CTBObject")
//    request.returnsObjectsAsFaults = false
//    
//    var predicate = NSPredicate(format: "name = %@ && id != %d && suffix = nil", name, exceptId)
//    request.predicate = predicate
//    
//    var results = context.executeFetchRequest(request, error: error) as! [NSManagedObject]
//    ErrorLogger.logError(error, message: "Error fetching same name object")
//    
//    
//    if results.count <= 0 {
//      NSLog("Done fetching nil.")
//      return []
//    }
//    
//    var rawResults = results.map() {
//      (nsmObject:NSManagedObject) -> (CognitiveToyBoxObject) in
//      CognitiveToyBoxObjectBuilder().buildFromNSManagedObject(nsmObject)
//    }
//    
//    var filteredResults = rawResults.filter({ (object:CognitiveToyBoxObject) -> Bool in
//      object.suffix == nil
//    })
//    
//    NSLog("Done fetching \(filteredResults.count) objects with name = \(name)")
//    return filteredResults
//    
//  }
  
  /* return a random picked object where name=name */
  public class func getSameNameObjectList (name name:String,exceptId:Int = -1) -> [CognitiveToyBoxObject] {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var context:NSManagedObjectContext = appDelegate.managedObjectContext
    
    NSLog("Getting same name object list...")
    var error : NSErrorPointer = nil
    var request = NSFetchRequest(entityName: "CTBObject")
    request.returnsObjectsAsFaults = false
    
    var predicate = NSPredicate(format: "name = %@ && id != %d", name,exceptId)
    request.predicate = predicate
    
//    var results = context.executeFetchRequest(request, error: error) as! [NSManagedObject]
    var results:[NSManagedObject]!
    do {
      results = try context.executeFetchRequest(request) as! [NSManagedObject]
    }catch let error as NSError{
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error fetching same name object")
    }

    
//    ErrorLogger.logError(error, message: "Error fetching same name object")
    
    if results.count <= 0 {
      NSLog("Done fetching nil.")
      return []
    }
    
    var rawResults = results.map() {
      (nsmObject:NSManagedObject) -> (CognitiveToyBoxObject) in
      CognitiveToyBoxObjectBuilder().buildFromNSManagedObject(nsmObject)
    }
    
//    var filteredResults = rawResults.filter({ (object:CognitiveToyBoxObject) -> Bool in
//      object.suffix == nil
//    })
    
//    NSLog("Done fetching \(filteredResults.count) objects with name = \(name)")
    NSLog("Done fetching \(rawResults.count) objects with name = \(name)")
    return rawResults
    
  }

  
//  public class func getSameNameObject (#name:String, exceptId:Int = -1) -> CognitiveToyBoxObject? {
//    var results = getSameNameObjectList(name: name, exceptId: exceptId)
//    
//    if results.isEmpty {
//      return nil
//    }
//    
//    let ctbObject = results[Int(arc4random_uniform(UInt32(results.count)))]
//    NSLog("Done fetching \(ctbObject).")
//    return ctbObject
//  }
  
  public class func getSameNameObject (name name:String,exceptId:Int = -1) -> CognitiveToyBoxObject? {
    var results = getSameNameObjectList(name: name,exceptId:exceptId)
    
    if results.isEmpty {
      return nil
    }
    
    let ctbObject = results[Int(arc4random_uniform(UInt32(results.count)))]
    NSLog("Done fetching \(ctbObject).")
    return ctbObject
  }

  

  
//  public class func getDiffNameObjectList (#name:String, material:String?, color:String?, forNames:NSSet? = nil) -> [CognitiveToyBoxObject] {
//    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    var context:NSManagedObjectContext = appDelegate.managedObjectContext!
//    
//    NSLog("Getting different name list...")
//    var error : NSErrorPointer = nil
//    var request = NSFetchRequest(entityName: "CTBObject")
//    request.returnsObjectsAsFaults = false
//    
//    var predicate:NSPredicate! = nil
//    
//    // consider the condition that material = nil or color = nil
//    if material != nil && color != nil {
//      predicate = NSPredicate(format: "name != %@ && (material = %@ || color = %@) && suffix = nil", name, material!, color!)
//    } else if material != nil {
//      predicate = NSPredicate(format: "name != %@ && material = %@ && suffix = nil", name, material!)
//    } else if color != nil {
//      predicate = NSPredicate(format: "name != %@ && color = %@ && suffix = nil", name, color!)
//    } else {
//      predicate = NSPredicate(format: "name != %@ && suffix = nil", name)
////      NSLog("Done fetching nil.")
////      return [CognitiveToyBoxObject]()
//    }
//    
//    
//    
//    request.predicate = predicate
//    
//    var results = context.executeFetchRequest(request, error: error) as! [NSManagedObject]
//    ErrorLogger.logError(error, message: "Error fetching different name object")
//    
//    if forNames != nil {
//      results = results.filter() {
//        includeElement in
//        forNames!.containsObject(includeElement.valueForKey("name")!)
//      }
//    }
//    
//    if results.count <= 0 {
//      //      predicate = NSPredicate(format: "name != %@", name)
//      //      request.predicate = predicate
//      //      results = context.executeFetchRequest(request, error: error) as [NSManagedObject]
//      NSLog("Done fetching nil.")
//      return [CognitiveToyBoxObject]()
//    }
//    
//    var filteredResults = results.map() {
//      (nsmObject:NSManagedObject) -> (CognitiveToyBoxObject) in
//      CognitiveToyBoxObjectBuilder().buildFromNSManagedObject(nsmObject)
//    }
//    
//    NSLog("Done fetching \(filteredResults.count) objects with name != \(name)")
//    return filteredResults
//  }
  
  public class func getDiffNameObjectList (name name:String, forNames:NSSet? = nil) -> [CognitiveToyBoxObject] {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var context:NSManagedObjectContext = appDelegate.managedObjectContext
    
    NSLog("Getting different name list...")
    var error : NSErrorPointer = nil
    var request = NSFetchRequest(entityName: "CTBObject")
    request.returnsObjectsAsFaults = false
    
    var predicate:NSPredicate! = nil
    predicate = NSPredicate(format: "name != %@", name)
    
    request.predicate = predicate
    
//    var results = context.executeFetchRequest(request, error: error) as! [NSManagedObject]
    var results:[NSManagedObject]!
    do {
      results = try context.executeFetchRequest(request) as! [NSManagedObject]
    }catch let error as NSError{
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error fetching different name object")
    }
//    ErrorLogger.logError(error, message: "Error fetching different name object")
    
    if forNames != nil {
      results = results.filter() {
        includeElement in
        forNames!.containsObject(includeElement.valueForKey("name")!)
      }
    }
    
    if results.count <= 0 {
      NSLog("Done fetching nil.")
      return [CognitiveToyBoxObject]()
    }
    
    var filteredResults = results.map() {
      (nsmObject:NSManagedObject) -> (CognitiveToyBoxObject) in
      CognitiveToyBoxObjectBuilder().buildFromNSManagedObject(nsmObject)
    }
    
    NSLog("Done fetching \(filteredResults.count) objects with name != \(name)")
    return filteredResults
  }
  
  /* return a random picked object where name!=name, material=material or color=color */
//  public class func getDiffNameObject (#name:String, material:String?, color:String?, forNames:NSSet? = nil) -> CognitiveToyBoxObject? {
//    
//    var results = self.getDiffNameObjectList(name: name, material: material, color: color, forNames: forNames)
//    
//    if results.isEmpty {
//      return nil
//    }
//    
//    
//    
//    var ctbObject = results[Int(arc4random_uniform(UInt32(results.count)))]
//    NSLog("Done fetching \(ctbObject).")
//    return ctbObject
//  }
  
  public class func getDiffNameObject (name name:String, forNames:NSSet? = nil) -> CognitiveToyBoxObject? {
    
    var results = self.getDiffNameObjectList(name: name, forNames: forNames)
    
    if results.isEmpty {
      return nil
    }
    
    var ctbObject = results[Int(arc4random_uniform(UInt32(results.count)))]
    NSLog("Done fetching \(ctbObject).")
    return ctbObject
  }
  
  /* return a random picked object where name!=name, material!=material and color!=color */
//  public class func getDiffNameObjectTutorial (#name:String, material:String?, color:String?, forNames:NSSet? = nil) -> CognitiveToyBoxObject? {
//    
//    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    var context:NSManagedObjectContext = appDelegate.managedObjectContext!
//    
//    NSLog("Getting different name object...")
//    var error : NSErrorPointer = nil
//    var request = NSFetchRequest(entityName: "CTBObject_tutorial")
//    request.returnsObjectsAsFaults = false
//    
//    var predicate:NSPredicate! = nil
//    
//    // consider the condition that material = nil or color = nil
//    if material != nil && color != nil {
//      predicate = NSPredicate(format: "name != %@ && (material != %@ && color != %@) && suffix = nil", name, material!, color!)
//    } else if material != nil {
//      predicate = NSPredicate(format: "name != %@ && material != %@ && suffix = nil", name, material!)
//    } else if color != nil {
//      predicate = NSPredicate(format: "name != %@ && color != %@ && suffix = nil", name, color!)
//    } else {
//      //      predicate = NSPredicate(format: "name != %@", name)
//      NSLog("Done fetching nil.")
//      return nil
//    }
//    
//    
//    
//    request.predicate = predicate
//    
//    var results = context.executeFetchRequest(request, error: error) as! [NSManagedObject]
//    ErrorLogger.logError(error, message: "Error fetching different name object")
//    
//    if forNames != nil {
//      results = results.filter() {
//        includeElement in
//        forNames!.containsObject(includeElement.valueForKey("name")!)
//      }
//    }
//    
//    if results.count <= 0 {
//      //      predicate = NSPredicate(format: "name != %@", name)
//      //      request.predicate = predicate
//      //      results = context.executeFetchRequest(request, error: error) as [NSManagedObject]
//      NSLog("Done fetching nil.")
//      return nil
//    }
//    
//    
//    
//    
//    
//    
//    let nsmObject = results[Int(arc4random_uniform(UInt32(results.count)))] as NSManagedObject
//    var ctbObject = CognitiveToyBoxObjectBuilder().buildFromNSManagedObject(nsmObject)
//    NSLog("Done fetching \(ctbObject).")
//    return ctbObject
//  }

  
  /* return all objects where name = name */
  public class func getSameNameAll (name name:String, limit:Int = -1) -> [CognitiveToyBoxObject] {
    if limit == 0 {
      return [CognitiveToyBoxObject]()
    }
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var context:NSManagedObjectContext = appDelegate.managedObjectContext
    
    NSLog("Getting same name list...")
    var error : NSErrorPointer = nil
    var request = NSFetchRequest(entityName: "CTBObject")
    request.returnsObjectsAsFaults = false
    
    var predicate = NSPredicate(format: "name = %@", name)
    request.predicate = predicate
    
    
//    var results : NSArray = context.executeFetchRequest(request, error: error)!
    var results = NSArray()
    do {
      results = try context.executeFetchRequest(request) as! [NSArray]
    }catch let error as NSError{
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error fetching all same objects")
    }
//    ErrorLogger.logError(error, message: "Error fetching all same objects")
    NSLog("Done.")
    
    var ctbArray = [CognitiveToyBoxObject]()
    for res : AnyObject in results {
      ctbArray.append(CognitiveToyBoxObjectBuilder().buildFromNSManagedObject(res as! NSManagedObject))
    }
    
    if limit > 0 && limit < results.count {
      ctbArray.shuffle()
      while limit < ctbArray.count {
        ctbArray.removeLast()
      }
    }
    
    return ctbArray
  }
    
  
}