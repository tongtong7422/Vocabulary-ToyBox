//
//  UserPerformanceHelper.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/30/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import CoreData

public struct PerformanceData: Printable {
  public var total: Int = 0
  public var correct: Int = 0
  public var accuracy: Float {
  get {
    if total != 0 {
      return Float(correct)/Float(total)
    } else {
      return 0
    }
  }
  }
  
  public var description: String {
  get {
    
    return (NSString(format: "%.0f", self.accuracy*100) as String) + "%"
  }
  }
}

/*
 * Provide utility functions accessing UserPerformance.
 *
 * class func update (#name:String, correct:Bool = true)
 *   update Core Data. record name, correctness and system time
 *
 * class func getPerformance () -> [String: Float]
 *   return user performance with name and percentage of correctness
 *
 * class func clear ()
 *   clear all data
 *
 * class func getFirstViewedNames (startDate: NSDate, endDate: NSDate) -> String[]
 *   return names that are first viewed by the user in the given time duration.
 */
public class UserPerformanceHelper {
  
  /* update Core Data. record name, correctness and system time */
  public class func update (#name:String, correct:Bool = true) {
    
    let now = NSDate(timeIntervalSinceNow: 0)
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDelegate.managedObjectContext!
    var error : NSErrorPointer = nil
    
    // check first appear
    var request = NSFetchRequest(entityName: "NameFirstAppear")
    var predicate = NSPredicate(format: "name = %@", name)
    
    request.predicate = predicate
    request.fetchLimit = 1
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
    
    var results = context.executeFetchRequest(request, error: error)!
    ErrorLogger.logError(error, message: "error in \(class_getName(self)).update")
    
    // set first appear
    var firstAppear: NameFirstAppear
    if results.count == 0 { // Thread unsafe
      firstAppear = NSEntityDescription.insertNewObjectForEntityForName("NameFirstAppear", inManagedObjectContext: context) as! NameFirstAppear
      firstAppear.name = name
      firstAppear.date = now
//      Flurry.logEvent("learnedNewObject", withParameters: ["name": name], timed: true)
    } else {
      firstAppear = results[0] as! NameFirstAppear
    }
    
    // set new performance
    var newPerformance = NSEntityDescription.insertNewObjectForEntityForName("UserPerformance", inManagedObjectContext: context) as! UserPerformance
    newPerformance.name = name
    newPerformance.correct = NSNumber(bool: correct)
    newPerformance.date = now
    newPerformance.firstAppear = firstAppear
    
    
    var saveError : NSErrorPointer = nil
    
    context.save(saveError)
    
    ErrorLogger.logError(saveError, message: "saveError in \(class_getName(self)).update")
    
    NSLog("User Performance Updated: name=\(name), correct=\(correct)")
    
//    if correct {
//      Flurry.logEvent("correctSelection", withParameters: ["name": name], timed: true)
//    } else {
//      Flurry.logEvent("wrongSelection", withParameters: ["name": name], timed: true)
//    }
  }
  
  /* return user performance with name and percentage of correctness */
  public class func getPerformance (date: NSDate? = nil) -> [String: PerformanceData] {
    
    var dateFrom: NSDate
    var dateTo: NSDate
    
    if date != nil {
      var boundary = DateHelper.getDayBoundary(date!)
      dateFrom = boundary.0
      dateTo  = boundary.1
    } else {
      dateFrom = NSDate(timeIntervalSinceReferenceDate: 0)
      dateTo = NSDate(timeIntervalSinceNow: 1)
    }
    return getPerformanceBetween(dateFrom: dateFrom, dateTo: dateTo)
  }
  
  /* performance between [dateFrom, dateTo) */
  public class func getPerformanceBetween (#dateFrom: NSDate, dateTo: NSDate) -> [String: PerformanceData] {
    
//    var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
    var calendar = NSCalendar.currentCalendar()
    var components: NSDateComponents
    
    var predicate : NSPredicate?
    
    var performance : [String: PerformanceData] = [:]
    
    // check if all names are updated
    var updated : [String: Bool] = [:]
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDelegate.managedObjectContext!
    
    /*
    select name, count(name)
    from UserPerformance
    where correct=true
    group by name
    */
    let expDesc = NSExpressionDescription()
    let keyPathExp = NSExpression(forKeyPath: "name")
    let countExp = NSExpression(forFunction: "count:", arguments: NSArray(object: keyPathExp) as [AnyObject])
    
    predicate = NSPredicate(format: "date >= %@ && date < %@", dateFrom, dateTo)
    
    expDesc.name = "count"
    expDesc.expression = countExp
    expDesc.expressionResultType = NSAttributeType.FloatAttributeType
    
    NSLog("Fetching total performance counts...")
    var request = NSFetchRequest(entityName: "UserPerformance")
    request.returnsObjectsAsFaults = false
    request.resultType = NSFetchRequestResultType.DictionaryResultType
    
    request.propertiesToFetch = NSArray(objects: "name", expDesc) as [AnyObject]
    request.propertiesToGroupBy = NSArray(object: "name") as [AnyObject]
    request.predicate = predicate
    
    var error : NSErrorPointer = nil
    
    
    
    
    // total number of each name
    var results : NSArray = context.executeFetchRequest(request, error: error)!
    
    ErrorLogger.logError(error, message: "error in \(class_getName(self)).getPerformance")
    
    var res : NSDictionary
    var name : String
    var count : Int
    for result : AnyObject in results {
      res = result as! NSDictionary
      name = res.valueForKey("name") as! String
      count = res.valueForKey("count") as! Int
      performance[name] = PerformanceData(total: count, correct: 0)
      updated[name] = false
    }
    NSLog("Count: \(performance)")
    NSLog("Done.")
    
    
    
    
    
    
    
    // number of correctness
    NSLog("Fetching correct performance counts...")
    predicate =
      NSPredicate(format: "date >= %@ && date < %@ && correct = %@", dateFrom, dateTo, NSNumber(bool: true))
    request.predicate = predicate
    results = context.executeFetchRequest(request, error: error)!
    
    ErrorLogger.logError(error, message: "error in \(class_getName(self)).getPerformance")
    
    for result : AnyObject in results {
      res = result as! NSDictionary
      name = res.valueForKey("name") as! String
      count = res.valueForKey("count") as! Int
      performance[name] = PerformanceData(total: performance[name]!.total, correct: count)
      updated[name] = true
    }
    
    
    
    
    
    
    
    
    // update names with no correct record
//    for (key, value) in updated {
//      if value {
//        continue
//      }
//      
//      performance[key] = PerformanceData()
//      
//    }
    
    
    
    NSLog("Performance: \(performance)")
    NSLog("Done.")
    
    return performance
  }
  
  /* first viewed names */
  public class func getFirstViewedNames (#dateFrom: NSDate, dateTo: NSDate) -> [String] {
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDelegate.managedObjectContext!
    var error : NSErrorPointer = nil
    
    var request = NSFetchRequest(entityName: "NameFirstAppear")
    var predicate = NSPredicate(format: "date >= %@ && date < %@", dateFrom, dateTo)
    request.predicate = predicate
    request.returnsObjectsAsFaults = false
    
    var results = context.executeFetchRequest(request, error: error) as! [NameFirstAppear]
    ErrorLogger.logError(error, message: "error in \(class_getName(self)).getFirstViewedNames")
    
    return results.map () {
      (firstAppear: NameFirstAppear) -> String in
      firstAppear.name
    }
  }
  
  /* clear all data */
  public class func clear () {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var context:NSManagedObjectContext = appDelegate.managedObjectContext!
    
    NSLog("Clearing user performance...")
    var request = NSFetchRequest(entityName: "UserPerformance")
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
    
    var error : NSErrorPointer = nil
    var saveError : NSErrorPointer = nil
    var results : NSArray = context.executeFetchRequest(request, error: error)!
    
    ErrorLogger.logError(error, message: "error in \(class_getName(self)).clear")
    
    if results.count > 0 {
      for res : AnyObject in results {
        context.deleteObject(res as! UserPerformance)
      }
    }
    
    request = NSFetchRequest(entityName: "NameFirstAppear")
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
    results = context.executeFetchRequest(request, error: error)!
    ErrorLogger.logError(error, message: "error in \(class_getName(self)).clear")
    
    if results.count > 0 {
      for res : AnyObject in results {
        context.deleteObject(res as! NameFirstAppear)
      }
    }
    
    context.save(saveError)
    
    ErrorLogger.logError(error, message: "saveError in \(class_getName(self)).clear")
    NSLog("Done.")
  }
  
  
}
