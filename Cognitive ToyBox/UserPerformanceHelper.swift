//
//  UserPerformanceHelper.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/30/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import CoreData

public struct PerformanceData: CustomStringConvertible {
  
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
  private var vocabularyCount: [String: Int] = [:]
  private var testNumber: Int = 0
  
  class var sharedInstance: UserPerformanceHelper {
    get {
      struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: UserPerformanceHelper? = nil
      }
      
      dispatch_once(&Static.onceToken) {
        Static.instance = UserPerformanceHelper()
        Static.instance!.vocabularyCount = UserPerformanceHelper.getVocabularyAppearance()
        Static.instance!.testNumber = UserPerformanceHelper.getTestNumberFromDataBase()
      }
      
      return Static.instance!
    }
  }
  
  public class func incrementVocabularyCount(name name:String, increment:Int=1){
    if sharedInstance.vocabularyCount[name] != nil {
        sharedInstance.vocabularyCount[name]!+=increment
    }else{
      sharedInstance.vocabularyCount[name] = 1
    }
    
  }
  public class func incrementTestNumber(){
    sharedInstance.testNumber += 1
  }
  
  public class func getDeadVocabularySet()->Set<String>{
    var wordDead:Set<String> = []
    
    for (word,count) in sharedInstance.vocabularyCount{
      if count>=5{
        wordDead.insert(word)
      }
    }
    return wordDead
  }
  
  public class func getTestNumber() -> Int{
    return sharedInstance.testNumber
  }
  
  
    /* update Core Data. record name, correctness and system time */
//  public class func update (#name:String, correct:Bool = true) {
//    
//    let now = NSDate(timeIntervalSinceNow: 0)
//    
//    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let context:NSManagedObjectContext = appDelegate.managedObjectContext!
//    var error : NSErrorPointer = nil
//    
//    // check first appear
//    var request = NSFetchRequest(entityName: "NameFirstAppear")
//    var predicate = NSPredicate(format: "name = %@", name)
//    
//    request.predicate = predicate
//    request.fetchLimit = 1
//    request.returnsObjectsAsFaults = false
//    request.includesPropertyValues = false
//    
//    var results = context.executeFetchRequest(request, error: error)!
//    incrementVocabularyCount(name:name)
//    ErrorLogger.logError(error, message: "error in \(class_getName(self)).update")
//    
//    // set first appear
//    var firstAppear: NameFirstAppear
//    if results.count == 0 { // Thread unsafe
//      firstAppear = NSEntityDescription.insertNewObjectForEntityForName("NameFirstAppear", inManagedObjectContext: context) as! NameFirstAppear
//      firstAppear.name = name
//      firstAppear.date = now
////      Flurry.logEvent("learnedNewObject", withParameters: ["name": name], timed: true)
//    } else {
//      firstAppear = results[0] as! NameFirstAppear
//    }
//    
//    // set new performance
//    var newPerformance = NSEntityDescription.insertNewObjectForEntityForName("UserPerformance", inManagedObjectContext: context) as! UserPerformance
//    newPerformance.name = name
//    newPerformance.correct = NSNumber(bool: correct)
//    newPerformance.date = now
//    newPerformance.firstAppear = firstAppear
//    
//    
//    var saveError : NSErrorPointer = nil
//    
//    context.save(saveError)
//    
//    ErrorLogger.logError(saveError, message: "saveError in \(class_getName(self)).update")
//    
//    NSLog("User Performance Updated: name=\(name), correct=\(correct)")
//    
////    if correct {
////      Flurry.logEvent("correctSelection", withParameters: ["name": name], timed: true)
////    } else {
////      Flurry.logEvent("wrongSelection", withParameters: ["name": name], timed: true)
////    }
//  }
  
  public class func update (name name:String, correct:Bool) {
    let now = NSDate(timeIntervalSinceNow: 0)

    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDelegate.managedObjectContext
    var error : NSError
    // check first appear
    var request = NSFetchRequest(entityName: "NameFirstAppear")
    var predicate = NSPredicate(format: "name = %@", name)
    
    request.predicate = predicate
    request.fetchLimit = 1
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
    
//    var results = context.executeFetchRequest(request, error: error)!
    var results = NSArray()
    do {
      results = try context.executeFetchRequest(request)
      // success ...
    } catch let error as NSError {
      // failure
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "error in \(class_getName(self)).update")
    }
    
    incrementVocabularyCount(name:name)
    incrementTestNumber()
//    ErrorLogger.logError(error, message: "error in \(class_getName(self)).update")
    
    // set first appear
    var firstAppear: NameFirstAppear
    if results.count == 0 { // Thread unsafe
      firstAppear = NSEntityDescription.insertNewObjectForEntityForName("NameFirstAppear", inManagedObjectContext: context) as! NameFirstAppear
      firstAppear.name = name
      firstAppear.date = now
      
      // set performance
      var newPerformance = NSEntityDescription.insertNewObjectForEntityForName("UserPerformance", inManagedObjectContext: context) as! UserPerformance
      
      newPerformance.name = name
      newPerformance.firstAppear = firstAppear
      if correct == true {
        newPerformance.correcttimes = 1
      }else {
        newPerformance.correcttimes = 0
      }
      newPerformance.appeartimes = 1
      
      var saveError : NSErrorPointer = nil
      
      do {
        try context.save()
        print("Person is updated")
        NSLog("New Performance Updated: name=\(name), firstAppear=\(firstAppear)")
      } catch let error as NSError {
        // failure
        print("Fetch failed: \(error.localizedDescription)")
      }

//      if context.save(saveError){
//        
//        println("Person is updated")
//        NSLog("New Performance Updated: name=\(name), firstAppear=\(firstAppear)")
//        
//      }else{
//        
//        ErrorLogger.logError(saveError, message: "saveError in \(class_getName(self)).update")
//        println("Could not save \(saveError), \(saveError.debugDescription)")
//        
//      }
      
    } else {
      firstAppear = results[0] as! NameFirstAppear
      print(firstAppear)
      // set new performance
      var request = NSFetchRequest(entityName: "UserPerformance")
      var predicate = NSPredicate(format: "name = %@", name)
      
      request.predicate = predicate
      request.fetchLimit = 1
      request.returnsObjectsAsFaults = false
      request.includesPropertyValues = false
      
//      var results = context.executeFetchRequest(request, error: error)!
//      let fetchResults = context.executeFetchRequest(request, error: error) as? [UserPerformance]
      var fetchResults : [UserPerformance]? = []
      do {
        fetchResults = try context.executeFetchRequest(request) as? [UserPerformance]
        
      } catch let error as NSError {
        
        print("Fetch failed: \(error.localizedDescription)")
      }
      
      if let nameRecords = fetchResults{
        if nameRecords.count == 0 {
            print("There is no data in userperformance")
        }
        let nameRecord = nameRecords[0]
        if correct == true {
          nameRecord.correcttimes += 1
        }

        nameRecord.appeartimes += 1
        
        
        do {
          try context.save()
          print("Person is updated")
          NSLog("New Performance Updated: name=\(name), correct=\(correct)")
          print(nameRecord)
        } catch let error as NSError {
          // failure
          print("Fetch failed: \(error.localizedDescription)")
          print(nameRecord)
        }
        
//        if context.save(saveError){
//          
//          println("Person is updated")
//          NSLog("User Performance Updated: name=\(name), correct=\(correct)")
//          println(nameRecord)
//        }else{
//          
//          ErrorLogger.logError(saveError, message: "saveError in \(class_getName(self)).update")
//          println("Could not save \(saveError), \(saveError.debugDescription)")
//          println(nameRecord)
//        }
        
      }

    }
    
  }
  
  
  /* return user performance with name and percentage of correctness */
//  public class func getPerformance (date: NSDate? = nil) -> [String: PerformanceData] {
//    
//    var dateFrom: NSDate
//    var dateTo: NSDate
//    
//    if date != nil {
//      var boundary = DateHelper.getDayBoundary(date!)
//      dateFrom = boundary.0
//      dateTo  = boundary.1
//    } else {
//      dateFrom = NSDate(timeIntervalSinceReferenceDate: 0)
//      dateTo = NSDate(timeIntervalSinceNow: 1)
//    }
//    return getPerformanceBetween(dateFrom: dateFrom, dateTo: dateTo)
//  }
  public class func getPerformance () -> [String: PerformanceData]{
    var performance : [String: PerformanceData] = [:]

      
      // check if all names are updated
      var updated : [String: Bool] = [:]
      var error : NSErrorPointer = nil

      let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let context:NSManagedObjectContext = appDelegate.managedObjectContext
    
      var request = NSFetchRequest(entityName: "UserPerformance")
      request.resultType = NSFetchRequestResultType.DictionaryResultType
//      var results : NSArray = context.executeFetchRequest(request, error: error)!
      var results = NSArray()
      do {
        results = try context.executeFetchRequest(request)
        // success ...
      } catch let error as NSError {
        // failure
        print("Fetch failed: \(error.localizedDescription)")
        ErrorLogger.logError(error, message: "error in \(class_getName(self)).getPerformance")
      }
//      ErrorLogger.logError(error, message: "error in \(class_getName(self)).getPerformance")
    
      var res : NSDictionary
      var name : String
      var appear : Int
      var correcttime : Int
      for result : AnyObject in results {
        res = result as! NSDictionary
        name = res.valueForKey("name") as! String
        appear = res.valueForKey("appeartimes") as! Int
        correcttime = res.valueForKey("correcttimes") as! Int
        performance[name] = PerformanceData(total: appear, correct: correcttime)
        updated[name] = false
      }
      return performance
    
  }

  
  /* performance between [dateFrom, dateTo) */
  public class func getPerformanceBetween (dateFrom dateFrom: NSDate, dateTo: NSDate) -> [String: PerformanceData] {
    
//    var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
    var calendar = NSCalendar.currentCalendar()
    var components: NSDateComponents
    
    var predicate : NSPredicate?
    
    var performance : [String: PerformanceData] = [:]
    
    // check if all names are updated
    var updated : [String: Bool] = [:]
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDelegate.managedObjectContext
    
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
//    var results : NSArray = context.executeFetchRequest(request, error: error)!
    var results = NSArray()
    do {
      results = try context.executeFetchRequest(request)
      // success ...
    } catch let error as NSError {
      // failure
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "error in \(class_getName(self)).getPerformance")
    }

    
//    ErrorLogger.logError(error, message: "error in \(class_getName(self)).getPerformance")
    
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
//    results = context.executeFetchRequest(request, error: error)!

    do {
      results = try context.executeFetchRequest(request)
      // success ...
    } catch let error as NSError {
      // failure
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "error in \(class_getName(self)).getPerformance")
    }

//    ErrorLogger.logError(error, message: "error in \(class_getName(self)).getPerformance")
    
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
  
  public class func getVocabularyAppearance () -> [String:Int]{
    var error: NSError?
    var vocabularyAppearance : [String: Int] = [:]
    
    // check if all names are updated
    var updated : [String: Bool] = [:]
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "UserPerformance")
    
//    let fetchResults = context.executeFetchRequest(fetchRequest, error: &error)

    do {
      let fetchResults = try context.executeFetchRequest(fetchRequest)
      let words =  fetchResults
      
      for word in words{
        //        res = word as! NSDictionary
        //        name = res.valueForKey("name") as! String
        //        count = res.valueForKey("appeartimes") as! Int
        
        vocabularyAppearance[word.name] = Int(word.appeartimes)
        updated[word.name] = false
      }
      NSLog("Count: \(vocabularyAppearance)")
      NSLog("Done.")
      
      // success ...
    } catch let error as NSError {
      // failure
      print("Fetch failed: \(error.localizedDescription)")
    }

//    if let words = fetchResults{
//      
//      for word in words{
//        //        res = word as! NSDictionary
//        //        name = res.valueForKey("name") as! String
//        //        count = res.valueForKey("appeartimes") as! Int
//        
//        vocabularyAppearance[word.name] = Int(word.appeartimes)
//        updated[word.name] = false
//      }
//      NSLog("Count: \(vocabularyAppearance)")
//      NSLog("Done.")
//      
//    }else{
//      println("Could not fetch \(error), \(error!.userInfo)")
//    }
    
    return vocabularyAppearance

  }
  
  public class func getTestNumberFromDataBase() -> Int{
    var error: NSError?
    var testNumber: Int = 0
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "UserPerformance")
//    let fetchResults = context.executeFetchRequest(fetchRequest, error: &error)
    
    do{
      let fetchResults = try context.executeFetchRequest(fetchRequest)
      let results = fetchResults
      for res in results {
      var appearTimes = res.valueForKey("appeartimes") as! Int
      testNumber += appearTimes
      }

    }catch let error as NSError {
      // failure
      print("Fetch failed: \(error.localizedDescription)")
      print("Could not get test number, \(error), \(error.userInfo)")
    }

//    if let results = fetchResults{
//      for res in results {
//        var appearTimes = res.valueForKey("appeartimes") as! Int
//        testNumber += appearTimes
//      }
//    }else{
//      print("Could not get test number, \(error), \(error!.userInfo)")
//    }
    
    return testNumber
  }
  
//  public class func getVocabularyAppearance () -> [String: Int] {
//    
//    //    var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
////    var calendar = NSCalendar.currentCalendar()
////    var components: NSDateComponents
//    
//    var predicate : NSPredicate?
//    
//    var vocabularyAppearance : [String: Int] = [:]
//    
//    // check if all names are updated
//    var updated : [String: Bool] = [:]
//    
//    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let context:NSManagedObjectContext = appDelegate.managedObjectContext!
//    
//    /*
//    select name, count(name)
//    from UserPerformance
//    where correct=true
//    group by name
//    */
//    let expDesc = NSExpressionDescription()
//    let keyPathExp = NSExpression(forKeyPath: "name")
//    let countExp = NSExpression(forFunction: "count:", arguments: NSArray(object: keyPathExp) as [AnyObject])
//    
////    predicate = NSPredicate(format: "date >= %@ && date < %@", dateFrom, dateTo)
//    
//    expDesc.name = "count"
//    expDesc.expression = countExp
//    expDesc.expressionResultType = NSAttributeType.FloatAttributeType
//    
//    NSLog("Fetching total performance counts...")
//    var request = NSFetchRequest(entityName: "UserPerformance")
//    request.returnsObjectsAsFaults = false
//    request.resultType = NSFetchRequestResultType.DictionaryResultType
//    
//    request.propertiesToFetch = NSArray(objects: "name", expDesc) as [AnyObject]
//    request.propertiesToGroupBy = NSArray(object: "name") as [AnyObject]
////    request.predicate = predicate
//    
//    var error : NSErrorPointer = nil
//    
//    
//    
//    // total number of each name
//    var results : NSArray = context.executeFetchRequest(request, error: error)!
//    
//    ErrorLogger.logError(error, message: "error in \(class_getName(self)).getPerformance")
//    
//    var res : NSDictionary
//    var name : String
//    var count : Int
//    for result : AnyObject in results {
//      res = result as! NSDictionary
//      name = res.valueForKey("name") as! String
//      count = res.valueForKey("count") as! Int
//      vocabularyAppearance[name] = count
//      updated[name] = false
//    }
//    NSLog("Count: \(vocabularyAppearance)")
//    NSLog("Done.")
//
//    
//    return vocabularyAppearance
//  }
  
  
  /* first viewed names */
  public class func getFirstViewedNames (dateFrom dateFrom: NSDate, dateTo: NSDate) -> [String] {
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDelegate.managedObjectContext

    
    var request = NSFetchRequest(entityName: "NameFirstAppear")
    var predicate = NSPredicate(format: "date >= %@ && date < %@", dateFrom, dateTo)
    request.predicate = predicate
    request.returnsObjectsAsFaults = false
    
//    var results = context.executeFetchRequest(request, error: error) as! [NameFirstAppear]
    var results:[NameFirstAppear]!
    do{
      results = try context.executeFetchRequest(request) as? [NameFirstAppear]
    }catch let error as NSError {
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "error in \(class_getName(self)).getFirstViewedNames")
    }
//    ErrorLogger.logError(error, message: "error in \(class_getName(self)).getFirstViewedNames")
    
    return results.map () {
      (firstAppear: NameFirstAppear) -> String in
      firstAppear.name
    }
  }
  
  /* clear all data */
  public class func clear () {
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var context:NSManagedObjectContext = appDelegate.managedObjectContext
    
    NSLog("Clearing user performance...")
    var request = NSFetchRequest(entityName: "UserPerformance")
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false

//    var results  : NSArray = context.executeFetchRequest(request, error: error)!
    var results = NSArray()
    do{
      results = try context.executeFetchRequest(request)
    }catch let error as NSError {
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "error in \(class_getName(self)).clear")
    }
    
//    ErrorLogger.logError(error, message: "error in \(class_getName(self)).clear")
    
    if results.count > 0 {
      for res : AnyObject in results {
        context.deleteObject(res as! UserPerformance)
      }
    }
    
    request = NSFetchRequest(entityName: "NameFirstAppear")
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
//    results = context.executeFetchRequest(request, error: error)!
    do{
      results = try context.executeFetchRequest(request)
    }catch let error as NSError {
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "error in \(class_getName(self)).clear")
    }
//    ErrorLogger.logError(error, message: "error in \(class_getName(self)).clear")
    
    if results.count > 0 {
      for res : AnyObject in results {
        context.deleteObject(res as! NameFirstAppear)
      }
    }
    
//    context.save(saveError)
    do {
      try context.save()

    } catch let error as NSError {
      // failure
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "saveError in \(class_getName(self)).clear")
    }

    
//    ErrorLogger.logError(error, message: "saveError in \(class_getName(self)).clear")
    sharedInstance.vocabularyCount = [:]
    sharedInstance.testNumber = 0
    NSLog("Done.")
  }
  
  
}
